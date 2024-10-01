{ config, lib, pkgs, inputs, values, ... }:

{
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    domain = lib.mkDefault "home.hafsmo.net";
    nameservers = lib.mkDefault [ "192.168.0.1" "1.1.1.1" "8.8.8.8" ]; #Check home nameserver and update first entry
    useDHCP = lib.mkDefault false;
  };

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16"; #Change to jetbrains-mono
    keyMap = lib.mkDefault "no";
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [ "omsfah" ];
      builders-use-substitutes = true;
    };

    registry= {
      nixpkgs.flake = inputs.nixpkgs;
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    bottom
    curl
    duf
    eza
    file
    git
    gnugrep
    gnutar
    htop
    iotop
    lm_sensors
    nix-output-monitor
    p7zip
    python3
    ranger
    rclone
    ripgrep
    rsync
    screen
    unzip
    usbutils
    vim
    wget
    zip
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      AuthenticationMethods publickey
    '';
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.omsfah = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    uid = lib.mkDefault 1000;
    openssh.authorizedKeys.keys = lib.mkDefault [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFB4MinWkZAzLx8QCUsKLoZbr7JuNvb7KdlBTko+nzuqAAAABHNzaDo= Token2, USB-A"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKFV44SCKl/29hQ48dytUr4uUGPuwP0FLbeJDCTwzxnDAAAABHNzaDo= Token2, USB-C"
    ];
    shell = pkgs.zsh;
  };
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}

