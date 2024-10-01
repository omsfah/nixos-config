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
  pkgs.tldr
  ];
  

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = rec {
      input ={
        "*" = {
          xkb_layout = "no";
          xkb_variant = "colemak";
        };
      };
	      modifier = "Mod4";
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "exec sleep 5; systemctl --user start kanshi.service";}
      ];
    };
  };
  
  home.stateVersion = "23.05";
}

