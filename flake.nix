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

      paths = {
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
      checks.${system} = {
        # Fail when committed Nix files are not formatted.
        formatting =
          legacy.runCommand "check-formatting"
            {
              nativeBuildInputs = [ legacy.nixfmt-tree ];
            }
            ''
              cp -r ${self} source
              chmod -R u+w source
              cd source

              # check fails if formatter needs to be invoked
              treefmt --ci

              # if formatter does not find anything, this line is executed, creating a file proving everything is formatted right
              touch "$out"
            '';

        # Fail when statix finds Nix antipatterns.
        statix =
          legacy.runCommand "check-statix"
            {
              nativeBuildInputs = [ legacy.statix ];
            }
            ''
              cd ${self}

              statixLog="$TMPDIR/statix.log"

              set +e
              statix check . > "$statixLog" 2>&1
              statixStatus=$?
              set -e

              cat "$statixLog"

              if [ "$statixStatus" -ne 0 ] || [ -s "$statixLog" ]; then
                exit 1
              fi

              touch "$out"
            '';

        # Fail when deadnix finds unused Nix code.
        deadnix =
          legacy.runCommand "check-deadnix"
            {
              nativeBuildInputs = [ legacy.deadnix ];
            }
            ''
              cd ${self}

              deadnix --fail .

              touch "$out"
            '';
        # Build the complete NixOS configuration, Home Manager configuration.
        nyx = self.nixosConfigurations.nyx.config.system.build.toplevel;
      };

      formatter.${system} = legacy.nixfmt-tree;
    };
}
