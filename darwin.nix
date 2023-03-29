{ config, pkgs, systemName, data, ... }:

{
  nix.settings.trusted-users = [ "root" data.username ];
  services.nix-daemon.enable = true;
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.starship
      pkgs.libiconv
      pkgs.darwin.apple_sdk.sdk
      # pkgs.darwin.apple_sdk.frameworks.CoreFoundation
      # pkgs.darwin.apple_sdk.frameworks.CoreServices
      # pkgs.darwin.apple_sdk.frameworks.Security
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  system.defaults.dock.orientation = "right";
  system.defaults.CustomUserPreferences = {
    "com.apple.dock" = {
      orientation = "bottom";
      autohide = true;
    };
  };
  networking.computerName = data.hostname;

  environment.shellAliases = {
    fooAlias = "echo 'foo alias'";
  };

  system.activationScripts.preActivation.text = ''
    echo "In preActivation"
  '';

  homebrew = {
    enable = true;
    brews = [
      "lima"
    ];
  };
}
