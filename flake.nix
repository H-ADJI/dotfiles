{
  description = "PDE dev shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          packages = with pkgs; [ ];
          shellHook = "";
        };
        # alternative shell profile : nix develop .#special
        special = pkgs.mkShell { };
      };
    };
}
