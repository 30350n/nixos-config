# NixOS Configuration

## Installation

### Using [minimal ISO image](https://nixos.org/download/)

```shell
$ sudo nix --experimental-features "nix-command flakes" run github:30350n/nixos-core#install -- https://github.com/30350n/nixos-config
```

### Using [custom nixos-core#nixos-iso image](https://github.com/30350n/nixos-core#building-custom-nixos-corenixos-iso-image)

```shell
$ sudo nixos-core-install https://github.com/30350n/nixos-config
```
