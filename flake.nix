{
  description = "My System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors"; 

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  

  };

  outputs = {
    self
    , home-manager
    , nix-colors
    , nixpkgs
    , sops-nix
    , nixos-hardware
    , unstable
  , ... }@inputs:
    let
      overlay-unstable = final: prev: {
        unstable = unstable.legacyPackages.${prev.system};
      };
    in
    {
      nixosConfigurations = {

        marjory = nixpkgs.lib.nixosSystem {
          system = "x84_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/marjory/configuration.nix
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."omsfah" = import ./home;
              home-manager.backupFileExtension = "bac";
              home-manager.extraSpecialArgs = {inherit nix-colors inputs;};
            }
            #need to choose one. The nixos one has bootloader and display manager in addition to the home manager one.
          ];
        };
        wembley = nixpkgs.lib.nixosSystem {
          system = "x84_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/wembley/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."omsfah" = import ./home;
              home-manager.backupFileExtension = "bac";
              home-manager.extraSpecialArgs = {inherit nix-colors inputs;};
            }
            #need to choose one. The nixos one has bootloader and display manager in addition to the home manager one.
          ];
        };
        boober = nixpkgs.lib.nixosSystem {
          system = "x84_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./hosts/boober/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."omsfah" = import ./home;
              home-manager.backupFileExtension = "bac";
              home-manager.extraSpecialArgs = {inherit nix-colors inputs;};
            }
            #need to choose one. The nixos one has bootloader and display manager in addition to the h    ome manager one.
          ];
        };
      };
    };
}
