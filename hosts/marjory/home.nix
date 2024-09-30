{ pkgs, lib, ... }:
{

  imports = [
    ./../../home/base.nix
  ];

  programs = {
    zsh.shellAliases."rebuild" = "sudo nixos-rebuild switch --flake /config";
  };

  home.stateVersion = "23.05";
}

