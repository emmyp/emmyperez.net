# Personal website
[![built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

The project repo for my personal website [emmyperez.net](https://emmyperez.net)

## Getting started
To be able to build this project, make sure to have [Nix](https://nixos.org/download/) set up. After that, you can use one of the following dependencies install options:

- Install [direnv](https://direnv.net/) and run `direnv allow .` in the project's root directory to active the `.envrc` config
- Run `nix develop` to open a shell using `flake.nix`
  - Optionally, the `--ignore-environment` flag can be set to create a [pure shell](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-develop#opt-ignore-environment)
