{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "waltermoreira";
  home.homeDirectory = "/Users/waltermoreira";
  home.sessionVariables = { FOO = "foo"; };

  home.packages = [
    pkgs.bashInteractive
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.vim = {
    enable = true;
    settings = {
      background = "light";
    };
    extraConfig = ''
      syntax off
    '';
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userName = "Foo Bar";
    userEmail = "foo@bar.com";
  };

  programs.bash = {
    enable = true;
  };
}
