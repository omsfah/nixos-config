# nixos-config
Configuration/ dotfiles for nixos hosts and services

# Upon starting a new host

1. Install normally from ISO file.
2. cp /etc/nixos/configuration.nix to git hosts/<hostname>/
3. cp /etc/nixos/hardware-configuration.nix to git hosts/<hostname>/

## Rebuild command
```
sudo nixos-rebuild switch --update-input nixpkgs --update-input unstable --no-write-lock-file --refresh --flake .#<insert-hostname> --upgrade --impure
```

