{ config, pkgs, systemName, data, newPkgs, newPkgs25, ... }:

{
  nix = {
    settings.trusted-users = [ "root" data.username ];
  } // 
  pkgs.lib.attrsets.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    package = newPkgs25.nixVersions.nix_2_28;
  };
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.starship
      pkgs.libiconv
      pkgs.darwin.apple_sdk.sdkRoot
      pkgs.darwin.apple_sdk.frameworks.CoreFoundation
      pkgs.darwin.apple_sdk.frameworks.CoreServices
      pkgs.darwin.apple_sdk.frameworks.Security
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

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.controlcenter.BatteryShowPercentage = true;
  system.defaults.universalaccess.reduceTransparency = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.controlcenter.Bluetooth = true;
  system.defaults.controlcenter.Sound = true;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.persistent-apps = [
    {
      app = "/System/Applications/Messages.app";
    }
  ];
  system.defaults.CustomUserPreferences = {
    "com.apple.dock" = {
      orientation = "bottom";
      autohide = true;
    };
    "com.apple.AppleMultitouchTrackpad" = {
      TrackpadThreeFingerDrag = true;
    };
    "com.apple.assistant.support" = {
      "Search Queries Data Sharing Status" = 2;
    };
    "com.apple.systemuiserver" = {
      menuExtras = [
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
      ];
    };
    "com.apple.TextInputMenu" = {
      visible = true;
    };
  };
  networking.computerName = data.hostname;

  environment.shellAliases = {
    fooAlias = "echo 'foo alias'";
  };

  system.activationScripts = {
    preActivation.text = ''
      ln -sf /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem
    '';
    postUserActivation.text = ''
      /opt/homebrew/bin/defaultbrowser firefox
      automator -i Aesthetic-vintage-flower-rose-background.jpg wallpaper.workflow
    '';
  };

  fonts.packages = [
    pkgs.victor-mono
  ];

  homebrew = {
    enable = true;
    brews = [
      "lima"
      "lastpass-cli"
      "defaultbrowser"
      "docker"
      "gh"
      "openconnect"
      {
        name = "java";
        link = true;
      }
    ];
    casks = [
      "homerow"
      "visual-studio-code"
      "firefox"
      "google-chrome"
      "gimp"
      "telegram"
      "signal"
      "xbar"
      "karabiner-elements"
    ];
  };

  security.sudo.extraConfig = ''
    root            ALL = (ALL) NOPASSWD: ALL
    %admin          ALL = (ALL) NOPASSWD: ALL
  '';

  system.stateVersion = 6;
}
