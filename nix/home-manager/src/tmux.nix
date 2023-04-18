{ pkgs, ... }:

{
  programs.tmux.enable = true;
  programs.tmux.tmuxinator.enable = true;
  programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  programs.tmux.terminal = "screen-256color";
  programs.tmux.extraConfig = "set -g mouse on";
  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    sidebar
    {
      plugin = dracula;
	    extraConfig = ''
	      set -g @dracula-show-battery true
	      set -g @dracula-show-powerline true
        set -g @dracula-show-fahrenheit false
	      set -g @dracula-refresh-rate 10
	    '';
    }
  ];
}
