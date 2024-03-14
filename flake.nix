{
  description = "Walter's Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs";
    new-nixpkgs.url = "github:nixos/nixpkgs/24.05-pre";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurl = {
      url = "github:nix-community/nurl";
    };
    myvscode = {
      url = "github:waltermoreira/myvscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , new-nixpkgs
    , home-manager
    , darwin
    , rust-overlay
    , nix-index-database
    , nurl
    , myvscode
    , ...
    }:
    let
      homes = import ./systems.nix;
      pkgsForSystem = system:
        import nixpkgs {
          inherit system;
          overlays = [
            (import rust-overlay)
            (final: prev: {
              nurl = nurl.packages.${system}.default;
            })
            (final: prev: {
              makeMyVSCode = myvscode.makeMyVSCode final;
            })
          ];
          config.allowUnfree = true;
        };
      newPkgsForSystem = system:
        import new-nixpkgs {
          inherit system;
        };
      configurationForHome = systemName: data:
        home-manager.lib.homeManagerConfiguration {
          pkgs = (pkgsForSystem data.system);
          modules = [
            ./home.nix
            nix-index-database.hmModules.nix-index
          ];
          extraSpecialArgs = {
            inherit systemName data;
            newPkgs = newPkgsForSystem data.system;
          };
        };
      darwinConfiguration = systemName: data:
        darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = {
            inherit systemName data;
            newPkgs = newPkgsForSystem data.system;
          };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${data.username}.imports = [
                ./home.nix
                nix-index-database.hmModules.nix-index
              ];

              users = {
                users = {
                  waltermoreira = {
                    shell = nixpkgs.legacyPackages.${data.system}.zsh;
                    description = data.fullName;
                    home = data.homeDirectory;
                  };
                };
              };

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
              home-manager.extraSpecialArgs = {
                inherit systemName data;
                pkgs = (pkgsForSystem data.system);
                newPkgs = (newPkgsForSystem data.system);
              };
            }
            ./darwin.nix
          ];
        };
    in
    {
      homeConfigurations = builtins.mapAttrs configurationForHome homes;
      darwinConfigurations = builtins.mapAttrs darwinConfiguration homes;
    };
}
