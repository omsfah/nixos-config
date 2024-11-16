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
    git = {
      userName = "Olaf Hafsmo";
      userEmail = "olafhafsmo@gmail.com";
    };
    swaylock = {
      enable = true;
      settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
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
    logseq
    element-desktop
    bluetuith
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
#        keybindings = {
#          "${modifier} + l"= "exec swaylock";
#        };
      };
      modifier = "Mod4";
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "sleep 5; systemctl --user start kanshi.service";}
        {command = "${pkgs.autotiling-rs}/bin/autotiling-rs";} #Adds autotiling dynamically when sway is enabled.
      ];
    };
  };
  
  home.stateVersion = "23.05";
}

