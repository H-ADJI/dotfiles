{
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    musnix = {
      url = "github:musnix/musnix";
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      noctalia,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./home.nix
          home-manager.nixosModules.home-manager
          inputs.musnix.nixosModules.musnix
          {
            musnix.enable = true;
            musnix.kernel.realtime = true;
          }
        ];
      };
    };
}
