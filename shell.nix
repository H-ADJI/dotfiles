{ nixpkgs }:

nixpkgs.lib.genAttrs
  [
    "x86_64-linux"
    "aarch64-darwin"
  ]
  (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          yq-go
        ];
        shellHook = ''
          export PATH="$PWD/common/git:$PATH"
        '';
      };

      # alternative shell profile : nix develop .#special
      special = pkgs.mkShell { };
    }
  )
