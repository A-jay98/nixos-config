{ pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 10000;

      ohMyZsh = {
        # Plug-ins
        enable = true;
        plugins = [ "git" ];
        custom = "~/.config/zsh_nix/custom";
      };

      shellInit = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
      ''; # Theming
    };
  };
}
