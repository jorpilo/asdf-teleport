<div align="center">

# asdf-tsh [![Build](https://github.com/jorpilo/asdf-tsh/actions/workflows/build.yml/badge.svg)](https://github.com/jorpilo/asdf-tsh/actions/workflows/build.yml) [![Lint](https://github.com/jorpilo/asdf-tsh/actions/workflows/lint.yml/badge.svg)](https://github.com/jorpilo/asdf-tsh/actions/workflows/lint.yml)

[tsh](https://goteleport.com/docs/connect-your-client/tsh) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add tsh
# or
asdf plugin add tsh https://github.com/jorpilo/asdf-tsh.git
```

tsh:

```shell
# Show all installable versions
asdf list-all tsh

# Install specific version
asdf install tsh latest

# Set a version globally (on your ~/.tool-versions file)
asdf global tsh latest

# Now tsh commands are available
tsh version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jorpilo/asdf-tsh/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jorge Pinilla López](https://github.com/jorpilo/)
