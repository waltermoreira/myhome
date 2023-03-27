{ config, pkgs, systemName, data, ... }:

let
  myWombat = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-wombat256grf";
    src = pkgs.fetchFromGitHub {
      owner = "gryf";
      repo = "wombat256grf";
      rev = "c54f6e5d6ef3e5b340ee830b5fe09633b044a23a";
      sha256 = "086jl0bx83a3n259mal1sd0zg53iazl9z91iwfs4nrlabrp6nqh5";
    };
  };
  onlyDarwinPackages =
    let
      notifier = pkgs.writeShellApplication {
        name = "notifier";
        text = ''
          osascript -e "display notification \"$1\" with title \"$2\""
        '';
      };
    in
    pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      notifier
    ];
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = data.username;
  home.homeDirectory = data.homeDirectory;
  home.sessionVariables = {
    FOO = "foobar";
  } // (if pkgs.stdenv.hostPlatform.isLinux then {
    LD_LIBRARY_PATH = "${pkgs.zlib}/lib";
  } else {
    DYLD_FALLBACK_LIBRARY_PATH = "${pkgs.zlib}/lib";
  });

  home.packages = with pkgs; [
    bashInteractive
    gitFull
    fzf-zsh
    zsh-fzf-tab
    fzf
    ripgrep
    bat-extras.batpipe
    starship
    ponysay
    lesspipe
    du-dust
    zlib
    duf
    nurl
    cmake
    gcc
    rust-script
    libiconv
    pkg-config
    (python310Full.withPackages (p: [ p.numpy ]))
    poetry
    (rust-bin.stable.latest.default.override
      {
        extensions = [ "rust-src" ];
        targets = [
          "wasm32-unknown-unknown"
          "x86_64-unknown-linux-gnu"
          "aarch64-unknown-linux-gnu"
          "x86_64-apple-darwin"
          "aarch64-apple-darwin"
        ];
      })
  ] ++ onlyDarwinPackages;

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
    plugins = with pkgs.vimPlugins; [
      easymotion
      vim-airline
      vim-airline-themes
      myWombat
      undotree
    ];
    extraConfig = ''
      filetype off
      set nocompatible
      let mapleader=" "
      syntax on
      filetype plugin indent on 
      set ts=4
      set autoindent
      set expandtab
      set shiftwidth=4
      set showmatch
      let python_highlight_all = 1
      au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
      autocmd FileType yaml setlocal ts=3 sts=2 sw=2 expandtab
      set hidden
      set cursorline
      colo wombat256grf
      hi CursorLine guibg=Gray21
      hi EasyMotionTargetDefault guifg=Green
      hi Visual term=reverse cterm=reverse guibg=Gray29
      let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'
      let g:auto_save = 1
      let g:ctrlp_cmd = 'CtrlPBuffer'
      set wildmenu
      set wildmode=longest:full
      set guioptions=egm
      set sidescroll=1
      set mouse=a
      let g:netrw_list_hide= '.*\.swp$'
      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_new_list_item_indent = 4
      autocmd BufWritePre *.py execute ':Black'
      au! BufNewFile,BufReadPost *.md set formatoptions+=a
      let g:workspace_session_disable_on_args = 1
      let g:workspace_autosave = 0
      set autoread
      map <Leader> <Plug>(easymotion-prefix)
    '';
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = data.fullName;
    userEmail = data.gitEmail;
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      gl = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    extraConfig = {
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      push.default = "simple";
      init.defaultBranch = "main";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = false;
    envExtra = ''
      if [[ -d $HOME/.dots ]]; then
        dotgit() { git --git-dir=$HOME/.dots --work-tree=$HOME $* }
        dotgit config --local status.showUntrackedFiles no
      fi
    '';
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
      c = {
        format = ''[\[$symbol($version(-$name))\]]($style)'';
      };
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
  programs.less.enable = true;
  programs.lesspipe.enable = true;

  xdg = pkgs.lib.attrsets.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    configFile."pypoetry/config.toml".text = ''
      [virtualenvs]
      in-project = true
    '';
  };

  home.file =
    pkgs.lib.attrsets.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      "Library/Preferences/pypoetry/config.toml".text = ''
        [virtualenvs]
        in-project = true
      '';
    };
}

