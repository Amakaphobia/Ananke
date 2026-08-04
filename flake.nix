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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index-database comma
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # customizable spotify wrapper
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

      paths = {
        root = ./.;
        wallpaper = ./assets/wallpapers;
        icons = ./assets/icons;
        profiles = ./profiles;
        modules = ./modules;
        users = ./users;
        hosts = ./hosts;
        scripts = ./scripts;
        lib = ./lib;
        themes = ./themes;
      };
    in
    {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit
            inputs
            paths
            ;
        };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops

          ./hosts/nyx

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                stylix.homeModules.stylix
                inputs.nixvim.homeModules.nixvim
                inputs.spicetify-nix.homeManagerModules.spicetify
                inputs.nix-index-database.homeModules.nix-index
              ];
              extraSpecialArgs = {
                inherit
                  inputs
                  paths
                  ;
              };
              users.akio = import ./users/home/akio;
              backupFileExtension = "backup";
            };
          }
          nur.modules.nixos.default
        ];
      };
      checks.${system} = import ./checks {
        inherit self paths;

        pkgs = legacy;
        nixosConfiguration = self.nixosConfigurations.nyx;
      };

      formatter.${system} = legacy.nixfmt-tree;
    };
}
