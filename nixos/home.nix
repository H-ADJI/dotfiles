{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/dotfiles/nixos/modules";
    };
    users.khalil = {
      imports = [
        inputs.noctalia.homeModules.default
        ./modules/ssh
        ./modules/assets
        ./modules/xdg
        ./modules/noctalia
        ./modules/television
        ./modules/hyprland
        ./modules/yazi
        ./modules/raffi
        ./modules/fuzzel
        ./modules/alacritty
        ./modules/nvim
        ./modules/zathura
        ./modules/glow
        ./modules/gtk
        ./modules/pulsemixer
        ./modules/wayscriber
        ./modules/hunk
        ./modules/jnv
        ./modules/jqp
        ./modules/tabiew
        ./modules/opencode
        ./modules/zsh
        ./modules/tmux
        ./modules/packages.nix
        ./modules/fastfetch.nix
        ./modules/taskwarrior.nix
        ./modules/git.nix
        ./modules/starship.nix
        ./modules/systemd.nix
        ./modules/nh.nix
        ./modules/ghostty.nix
        ./modules/satty.nix
      ];
      home.username = "khalil";
      home.homeDirectory = "/home/khalil";
      home.stateVersion = "26.05";
    };
  };
}
