{ config, pkgs, systemName, data, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = data.username;
  home.homeDirectory = data.homeDirectory;

  home.packages = with pkgs; [
    bashInteractive
    fzf-zsh
    zsh-fzf-tab
    fzf
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
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userName = data.fullName;
    userEmail = data.email;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    plugins = [
      {
        name = "fzf";
        src = "${pkgs.fzf-zsh}/share/zsh/plugins";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
