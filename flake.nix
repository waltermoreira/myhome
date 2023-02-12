{
  description = "Home Manager configuration of Walter";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      homes = {
        cnt = {
          username = "waltermoreira";
          homeDirectory = "/Users/waltermoreira";
          email = "wmoreira@cnt.canon.com";
          system = "x86_64-darwin";
        };
        limaVm = {
          username = "waltermoreira";
          homeDirectory = "/home/waltermoreira.linux";
          email = "walter@waltermoreira.net";
          system = "x86_64-linux";
        };
        calvin = {
          username = "walter";
          homeDirectory = "/Users/walter";
          email = "walter@waltermoreira.net";
          system = "x86_64-darwin";
        };
      };
      configurationForHome = systemName: data: 
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${data.system};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit systemName data;
          };
        };
    in {
      homeConfigurations = builtins.mapAttrs configurationForHome homes;
    };
}
