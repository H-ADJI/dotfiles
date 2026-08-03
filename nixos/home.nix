{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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
