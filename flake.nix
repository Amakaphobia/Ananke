{
  description = "First Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim for 26.05
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };

    # make firefox addons available via the nur overlay
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # temporarily pin this commit. It fixes waybar hyprland lua interaction
    waybar = {
      url = "github:Alexays/Waybar/05945748dccce28bf96d26d8f64a9e69a8dd49ba";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # load betterfox
    betterfox = {
      url = "github:yokoffing/Betterfox/152.0";
      flake = false;
    };
  };

  # @ syntax : name all of it inputs, but pull out the named variables and make them locally available
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nur,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";

      legacy = nixpkgs.legacyPackages.${system};

      homeModulesPath = ./home/modules;

      wallpapersPath = ./assets/wallpapers;
    in
    {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit
            inputs
            self
            ;
        };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel

          ./hosts/nyx

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                stylix.homeModules.stylix
                inputs.nixvim.homeModules.nixvim
              ];
              extraSpecialArgs = {
                inherit
                  inputs
                  homeModulesPath
                  wallpapersPath
                  ;
              };
              users.dave = import ./home/users/dave;
              backupFileExtension = "backup";
            };
          }
          nur.modules.nixos.default
        ];
      };

      formatter.${system} = legacy.nixfmt-tree;
    };
}
