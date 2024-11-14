{ pkgs, lib, ... }:
{

  programs = {
    zsh.shellAliases."rebuild" = "sudo nixos-rebuild switch --flake ~/git/nixos-config";
    zsh.enable = true;
    vim = {
      enable = true;
      defaultEditor = true;
      settings = {
        relativenumber = true;
      };
    };
  };
  home.packages = with pkgs; [
    firefox
    kicad
    discord
    logseq
    prusa-slicer
    libreoffice
    alacritty
    tldr
    autotiling-rs
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

