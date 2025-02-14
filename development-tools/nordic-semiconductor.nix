{ config, lib, pkgs, inputs, values, ... }:
{
  environment.systemPackages = with pkgs; [
    nrfutil
    nrf-udev
    nrfconnect
    nrf-command-line-tools
    python3Full
    cmake
    ninja
    gperf
    ccache
    dfu-util
    gnumake
    libgcc
    SDL2
    libunistring
    libpsl #Manually delete rm ~/ncs/toolchains/<your-hash>/usr/lib/x86_64-linux-gnu/libpsl.so.5* based on https://devzone.nordicsemi.com/f/nordic-q-a/106982/error-installing-nrf-connect-sdk-in-vscode-linux-libunistring-so-2-cannot-open-shared-object-file-no-such-file-or-directory
    e2fsprogs
    libxcrypt
    glibc
    libxcrypt-legacy
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true; #Needed for segger jlink, inturn needed for nordic
  nixpkgs.config.permittedInsecurePackages = ["segger-jlink-qt4-796s"];
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        cmake
        python3
        libidn2
        gnutls
        gmp
        libunistring
        libpsl
        e2fsprogs
        libxcrypt
        glibc
        libxcrypt-legacy
      ];
    };
  };
}
