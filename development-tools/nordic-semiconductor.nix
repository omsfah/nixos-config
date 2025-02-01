{ config, lib, pkgs, inputs, values, ... }:
{
  enviroments.systemPackages = with pkgs; [
    nrfutil
    nrf-udev
    nrfconnect
    python313
    python313Packages.west
    python313Packages.cmake
  ]
}
