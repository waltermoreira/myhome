{
  description = "Walter's Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = { nixpkgs, home-manager, darwin, rust-overlay, ... }:
    let
      fullName = "Walter Moreira";
      homes = {
        cnt = {
          inherit fullName;
          username = "waltermoreira";
          homeDirectory = "/Users/waltermoreira";
          email = "wmoreira@cnt.canon.com";
          system = "x86_64-darwin";
        };
        limaVm = {
          inherit fullName;
          username = "waltermoreira";
          homeDirectory = "/home/waltermoreira.linux";
          email = "walter@waltermoreira.net";
          system = "x86_64-linux";
        };
        calvin = {
          inherit fullName;
          username = "walter";
          homeDirectory = "/Users/walter";
          email = "walter@waltermoreira.net";
          system = "x86_64-darwin";
        };
      };
      pkgsForSystem = system:
        import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
      configurationForHome = systemName: data:
        home-manager.lib.homeManagerConfiguration {
          pkgs = (pkgsForSystem data.system);
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit systemName data;
          };
        };
      darwinConfiguration = systemName: data:
        darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${data.username} = import ./home.nix;

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
              };
            }
          ];
        };
    in
    {
      homeConfigurations = builtins.mapAttrs configurationForHome homes;
      darwinConfigurations = builtins.mapAttrs darwinConfiguration homes;
    };
}
