{ pkgs, lib, ... }:
{

  programs = {
    zsh.shellAliases."rebuild" = "sudo nixos-rebuild switch --flake ~/git/nixos-config";
  };
  
  home.packages= [
  pkgs.firefox
  pkgs.vim
  pkgs.kicad
  pkgs.discord
  pkgs.logseq
  pkgs.prusa-slicer
  pkgs.libreoffice
  pkgs.alacritty
  ];

  home.stateVersion = "23.05";
}

