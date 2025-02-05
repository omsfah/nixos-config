{ pkgs, lib, ... }:
{

  programs = {
    zsh.enable = true;
    zsh.shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/git/nixos-config";
    };
    vim = {
      enable = true;
      defaultEditor = true;
      settings = {
        relativenumber = true;
      };
    };
    git = {
      enable = true;
      userName = "Olaf Hafsmo";
      userEmail = "olafhafsmo@gmail.com";
      extraConfig = {
        push.autoSetupRemote = true;
      };

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
#      vscode = {
#        enable = true;
#        extensions = with pkgs.vscode-extensions; [
#          myriad-dreamin.tinymist
#        ];
#      };
  };

  home.packages = with pkgs; [
    alacritty
    bluetuith
    discord
    element-desktop
    firefox
    kicad
    libreoffice
#    logseq
    mako
    prusa-slicer
    tldr
    typst
    vscode-fhs
    freecad-wayland
    sway-contrib.grimshot
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
      "Mod4+Shift+s" = "exec grimshot --notify copy anything";
      };
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "sleep 5; systemctl --user start kanshi.service";}
        {command = "${pkgs.autotiling-rs}/bin/autotiling-rs";} #Adds autotiling dynamically when sway is enabled.
      ];
    };
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  xdg.mimeApps = {
    enable=true;
    defaultApplications = {
      "application/pdf" = ["firefox.desktop"];
    };
  };
  services = {
    
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock"; }
      ];
    };
    
    mako = {
      enable = true;
    };


    kanshi = {
      enable = true;
      systemdTarget = "sway-session.target";
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "BOE 0x084D Unknown";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "home_office";
          profile.outputs = [
            {
              criteria = "BOE 0x084D Unknown";
              position = "2370,0";
              mode = "1920x1080@144";
              transform = "normal";
            }
            {
              criteria = "Dell Inc. DELL U3818DW 5KC037B9066L";
              position = "1440,1080";
              mode = "3840x1600@60";
              transform = "normal";
            }
            {
              criteria = "Lenovo Group Limited LEN P27h-10 0x5A503047";
              position = "0,600";
              mode = "2560x1440@60";
              transform = "90";
            }
            {
              criteria = "Lenovo Group Limited LEN P27h-10 0x4C503044";
              position = "5280,600";
              mode = "2560x1440@60";
              transform = "270";
            }
          ];
        }
        {
          profile.name = "guru_office";
          profile.outputs = [
            {
              criteria = "BOE 0x084D Unknown";
              position = "860,1440";
              mode = "1920x1080@144";
              transform = "normal";
            }
            {
              criteria = "Dell Inc. DELL U3421WE C2BZ653";
              position = "0,0";
              mode = "3440x1440@59.97";
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "portable_office";
          profile.outputs = [
            {
              criteria = "BOE 0x084D Unknown";
              position = "0,0";
              mode = "1920x1080@144";
              transform = "normal";
            }
            {
              criteria = "ASUSTek COMPUTER INC ASUS MB166C MCLMTF049368";
              position = "1920,0";
              mode = "1920x1080@60";
              transform = "normal";
            }
          ];
        }
        {
          profile.name = "batchelor";
          profile.outputs = [
            {
              criteria = "NEC Corporation EA273WM 38112443NB";
              position = "0,0";
              mode = "1920x1080@60";
              transform = "normal";
            }
            {
              criteria = "NEC Corporation EA273WMi 51115330NB   ";
              position = "1920,0";
              mode = "1920x1080@60";
              transform = "normal";
            }
          ];
        }
      ];
    };
  };

  home.stateVersion = "24.11";
}

