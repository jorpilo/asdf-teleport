<div align="center">

# asdf-teleport [![Build](https://github.com/jorpilo/asdf-teleport/actions/workflows/build.yml/badge.svg)](https://github.com/jorpilo/asdf-teleport/actions/workflows/build.yml) [![Lint](https://github.com/jorpilo/asdf-teleport/actions/workflows/lint.yml/badge.svg)](https://github.com/jorpilo/asdf-teleport/actions/workflows/lint.yml)

[teleport|tsh](https://goteleport.com/docs/connect-your-client/tsh) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `jq` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `ASDF_OS`: set this environment variable in your shell config to install a different OS version of the tool
- `ASDF_ARCH`: set this environment variable in your shell config to install a different ARCH version of the tool

# Install

Plugin:

```shell
asdf plugin add teleport
# or
asdf plugin add teleport https://github.com/jorpilo/asdf-teleport.git
```

tsh:

```shell
# Show all installable versions
asdf list-all teleport

# Install specific version
asdf install teleport latest

# Set a version globally (on your ~/.tool-versions file)
asdf global teleport latest

# Now tsh commands are available
tsh version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jorpilo/asdf-teleport/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jorge Pinilla López](https://github.com/jorpilo/)
