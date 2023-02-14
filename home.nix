{ config, pkgs, systemName, data, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = data.username;
  home.homeDirectory = data.homeDirectory;
  home.sessionVariables = {
    FOO = "foo";
  };

  home.packages = with pkgs; [
    bashInteractive
    fzf-zsh
    zsh-fzf-tab
    fzf
    ripgrep
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

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

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
    enableSyntaxHighlighting = false;
    plugins = [
      {
        name = "fzf";
        src = "${pkgs.fzf-zsh}/share/zsh/plugins/fzf-zsh";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "fzf" ];
    };
    shellAliases = {
      l = "ls -la";
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
      aws.disabled = true;
      azure.disabled = true;
      buf.disabled = true;
      bun.disabled = true;
      cmake.disabled = true;
      cobol.disabled = true;
      cmd_duration.format = ''[\[⏱ $duration\]]($style)'';
      conda.disabled = true;
      crystal.disabled = true;
      daml.disabled = true;
      dart.disabled = true;
      deno.disabled = true;
      directory = {
        format = ''[\[[$path]($style)[$read_only]($read_only_style)\]]($style)'';
      };
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      erlang.disabled = true;
      gcloud.disabled = true;
      git_branch = {
        format = ''[\[$symbol$branch(:$remote_branch)\]]($style)'';
      };
      git_status = {
        format = ''([\[$all_status$ahead_behind\]]($style))'';
      };
      golang.disabled = true;
      guix_shell.disabled = true;
      haskell = {
        format = ''[\[$symbol($version)\]]($style)'';
      };
      haxe.disabled = true;
      helm.disabled = true;
      hostname = {
        ssh_symbol = "🌐";
        format = ''[\[$ssh_symbol$hostname\]]($style)'';
      };
      java.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      lua.disabled = true;
      meson.disabled = true;
      hg_branch.disabled = true;
      nim.disabled = true;
      nix_shell = {
        format = ''[\[$symbol$state( \($name\))\]]($style)'';
      };
      nodejs = {
        format = ''[\[$symbol($version)\]]($style)'';
      };
      ocaml.disabled = true;
      opa.disabled = true;
      openstack.disabled = true;
      os = {
        disabled = false;
        symbols = {
          Macos = "⌘ ";
        };
      };
      package = {
        format = ''[\[$symbol$version\]]($style)'';
      };
      perl.disabled = true;
      php.disabled = true;
      pulumi.disabled = true;
      purescript.disabled = true;
      python = {
        format = ''[\[$symbol$pyenv_prefix($version)(\($virtualenv\))\]]($style)'';
      };
      rlang.disabled = true;
      raku.disabled = true;
      ruby.disabled = true;
      rust = {
        format = ''[\[$symbol($version)\]]($style)'';
      };
      scala.disabled = true;
      singularity.disabled = true;
      spack.disabled = true;
      swift.disabled = true;
      terraform.disabled = true;
      username = {
        format = ''[\[$user\]]($style)'';
      };
      vagrant.disabled = true;
      vlang.disabled = true;
      vcsh.disabled = true;
      zig.disabled = true;
    };
  };

  programs.bat.enable = true;
}

