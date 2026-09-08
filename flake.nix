{
  description = "khalil's PDE - NixOS + macOS workstation configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    musnix = {
      url = "github:musnix/musnix";
    };
    hyprland-preview-share-picker = {
      url = "git+https://github.com/WhySoBad/hyprland-preview-share-picker.git?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      musnix,
      ...
    }@inputs:
    {
      devShells = import ./shell.nix { inherit nixpkgs; };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          musnix.nixosModules.musnix
          home-manager.nixosModules.home-manager
          ./nixos/home.nix
        ];
      };

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./macos/configuration.nix
          home-manager.darwinModules.home-manager
          ./macos/home.nix
        ];
      };
    };
}
