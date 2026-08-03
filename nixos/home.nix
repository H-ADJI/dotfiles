{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/dotfiles/nixos/modules";
    };
    users.khalil = {
      imports = [
        ./modules/ssh
        ./modules/alacritty
        ./modules/nvim
        ./modules/zsh
        ./modules/tmux
        ./modules/packages.nix
        ./modules/taskwarrior.nix
        ./modules/git.nix
        ./modules/starship.nix
      ];
      home.username = "khalil";
      home.homeDirectory = "/home/khalil";
      home.stateVersion = "25.11";
    };
  };
}
