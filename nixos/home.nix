{ inputs, pkgs, ... }:
let
  hyprlandPreviewSharePickerSrc = pkgs.fetchgit {
    url = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
    sha256 = "sha256-XE6RD/4Mhw/ZRBj0v94kLOERElat5V+e/X0L9eUGf7M=";
    fetchSubmodules = true;
  };
  hyprlandPreviewSharePicker = pkgs.callPackage "${hyprlandPreviewSharePickerSrc}/package.nix" {
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/PDE/nixos";
      inherit inputs;
    };
    users.khalil = {
      imports = [
        inputs.noctalia.homeModules.default
        ./alacritty
        ./assets
        ./direnv
        ./fastfetch
        ./fuzzel
        ./ghostty
        ./git
        ./glow
        ./gtk
        ./hunk
        ./hyprland
        ./jnv
        ./jqp
        ./nh
        ./noctalia
        ./nvim
        ./opencode
        ./pi-agent
        ./pulsemixer
        ./raffi
        ./satty
        ./share-picker
        ./ssh
        ./starship
        ./systemd
        ./tabiew
        ./taskwarrior
        ./television
        ./tmux
        ./wayscriber
        ./xdg
        ./yazi
        ./zathura
        ./zsh
      ];
      home.username = "khalil";
      home.homeDirectory = "/home/khalil";
      home.stateVersion = "26.05";
      home.packages = with pkgs; [
        # TODO: package : shuck / zshcs
        alacritty
        ardour
        bluetui
        brave
        devenv
        fd
        fuzzel
        fzf
        glow
        gnugrep
        google-chrome
        hunk
        hyperfine
        hyprlandPreviewSharePicker
        impala
        jnv
        jqp
        libnotify
        mpv
        nautilus
        neovim
        nerd-fonts.jetbrains-mono
        papirus-icon-theme
        playerctl
        pulsemixer
        raffi
        ripgrep
        slurp
        socat
        tabiew
        tree
        wayscriber
        wl-clipboard
        xre
      ];
    };
  };
}
