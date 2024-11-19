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
    alacritty
    bluetuith
    discord
    element-desktop
    firefox
    kicad
    libreoffice
    logseq
    prusa-slicer
    tldr
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
      keybindings = lib.mkOptionDefault { #By importing keybinds with mkOptionDefault it appends the keybind. If you only specify a keybind nixos won't import default keybinds from /etc/sway/config, so you'll need to add all keybinds
        "Mod1+Shift+l" = "exec swaylock";
      };
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "sleep 5; systemctl --user start kanshi.service";}
        {command = "${pkgs.autotiling-rs}/bin/autotiling-rs";} #Adds autotiling dynamically when sway is enabled.
      ];
    };
  };

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock"; }
      ];
    };
  };

  home.stateVersion = "23.05";
}

