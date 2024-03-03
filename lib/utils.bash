#!/usr/bin/env bash

set -euo pipefail

PLUGIN_NAME="asdf-tsh"
RELEASES_URL="https://goteleport.com/download"
GH_REPO="https://github.com/gravitational/teleport"
TOOL_NAME="tsh"
TOOL_TEST="tsh version"

echodebug() { printf "%s\n" "$*" >&2; }

fail() {
	echo -e "$PLUGIN_NAME: $* failed"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if tsh is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

download_versions() {
	curl "${curl_opts[@]}" -s "${RELEASES_URL}" |
		grep -oE '<script id="__NEXT_DATA__" type="application\/json">(.+)<\/script>' |
		sed 's/<script id="__NEXT_DATA__" type="application\/json">//; s/<\/script>//' |
		jq '.props.pageProps.initialDownloads[].versions' |
		jq -s 'flatten | sort_by(.version) | reverse'
}

filter_prerelease() {
	jq 'map(select(.status == "published"))'
}

parse_versions() {
	jq '.[].version' | jq -rs '@sh'
}

select_version() {
	version="$1"
	if ! jq -e --arg version "$version" 'map(select(.version | startswith($version)))| first'; then
		fail "Could not parse version $version from $RELEASES_URL"
	fi | jq '.assets[] + {version: .version}'
}

filter_os() {
	local supported_os
	os="$1"
	supported_os=("linux" "darwin" "windows")
	if [[ ! ${supported_os[*]} =~ $os ]]; then
		fail "Unsupported OS: $os"
	fi
	jq -e --arg os "$os" 'select(.os == $os)'
}

filter_arch() {
	arch=$1
	supported_arch=("amd64" "arm64")
	if [[ ! ${supported_arch[*]} =~ $arch ]]; then
		fail "Unsupported architecture: $arch"
	fi
	jq -e --arg arch "$arch" 'select(.arch == $arch)'
}

filter_type() {
	type=$1
	supported_type=("tar.gz")
	if [[ ! ${supported_type[*]} =~ $type ]]; then
		fail "Unsupported type: $type"
	fi
	jq -e --arg type "$type" 'select(.type == $type)'

}

detect_os() {
	local machine unameOut

	unameOut="$(uname -s)"
	case "${unameOut}" in
	Linux*) machine=linux ;;
	Darwin*) machine=darwin ;;
	*) machine="UNKNOWN:${unameOut}" ;;
	esac
	if [[ "${machine}" == UNKNOWN:* ]]; then
		fail "Unsupported OS: $machine"
	fi
	echo "$machine"
}

detect_arch() {
	local architecture unameOut
	unameOut=$(uname -m)
	case "${unameOut}" in
	i386 | i686) architecture="386" ;;
	x86_64 | amd64) architecture="amd64" ;;
	aarch64) architecture="arm64" ;;
	arm*) architecture="arm" ;;
	*) architecture="UNKNOWN:${unameOut}" ;;
	esac

	if [[ "${architecture}" == UNKNOWN:* ]]; then
		fail "Unsupported architecture: $architecture"
	fi

	echo "$architecture"
}

download_release() {
	local url filename
	url="$1"
	filename="$2"

	echo "* Downloading $url into $filename"
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

check_sha256() {
	local filename expected_sha256
	filename="$1"
	expected_sha256="$2"

	echo "* Checking sha256 of $filename"
	actual_sha256=$(shasum -a 256 "$filename" | cut -d' ' -f1)
	if [ "$actual_sha256" != "$expected_sha256" ]; then
		fail "SHA256 mismatch for $filename: expected $expected_sha256, got $actual_sha256"
	fi
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH/"{teleport,tctl,tsh,tbot} "$install_path"

		# TODO: Assert tsh executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
