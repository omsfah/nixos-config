# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../base.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wembley"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  ##
  #  Wireguard
  ##

  networking.firewall={
    allowedUDPPorts = [ 51820 ];
  };
  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.60.5/32" ];
      listenPort = 51820;
      privateKey = "qBWWRPZKlhEv7Q1S7WA/CkuPuKo+o1DrXVGwhosY8EU=";
      peers = [
        {
          publicKey = "NsbcClYKPutKXWLyjBPIGlJUE4HZbmZsg3Nt+h9OLAw=";
          presharedKeyFile = "/home/omsfah/wireguard_presharedkey.psk";
          allowedIPs = [ "192.168.0.0/16" ];
          name = "test";
          endpoint = "vpn.hafsmo.net:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  

    # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY="wayland-1";
      DISPLAY = ":0";
    }; 
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };  

  

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the Gnome Desktop Environment.
  services.displayManager.sessionPackages = [ pkgs.sway ]; # Dependency for sway in gddm
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "colemak";
  };
  
#  services.greetd = {                                                      
#    enable = true;                                                         
#    settings = {                                                           
#      default_session = {                                                  
#        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
#        user = "omsfah"; #Something wrong here                                                 
#      };                                                                   
#    };                                                                     
#  };
  

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.spacenavd.enable = true;
  security = {
  rtkit.enable = true;
  polkit.enable = true; #Sway dependency, see https://wiki.nixos.org/wiki/Sway#Using_Home_Manager
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omsfah = {
    isNormalUser = true;
    description = "Olaf Hafsmo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  # Install sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  # Install Steam
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #Electron support for discord
  nixpkgs.config.permittedInsecurePackages = [
                "electron-27.3.11"
              ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pavucontrol
    mesa
    vulkan-tools
    spacenavd
    spacenav-cube-example
  ];
#  environment.variables = {
#    WLR_SCENE_DISABLE_DIRECT_SCANOUT = "1";
#    WLR_RENDERER = "vulkan";
#  };

  services.xserver = {
    videoDrivers = [ "nouveau" ];
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      mesa.drivers
    ];
  };
  ##
  # Nvidia
  ##
#  services.xserver.videoDrivers =["nvidia"];
#  hardware = {
#    graphics.enable = true;
#    nvidia = {
#      modesetting.enable = true;
#      powerManagement.enable = false;
#      open = true;
#      nvidiaSettings = true;
#      package = config.boot.kernelPackages.nvidiaPackages.stable;
#      prime = {
#        sync.enable = true;
#        intelBusId = "PCI:0:2:0";
#        nvidiaBusId = "PCI:1:0:0";
#      };
#    };
#    graphics.extraPackages = with pkgs; [
#      vulkan-validation-layers
#    ];
#  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
