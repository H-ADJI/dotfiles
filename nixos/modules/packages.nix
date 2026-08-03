{ pkgs, ... }:

{
  home.packages = with pkgs; [
	alacritty
	google-chrome
	neovim
	fuzzel
	tree
  ];
}
