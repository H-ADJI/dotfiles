{
  description = "PDE dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nixfmt
          statix
          lua-language-server
          stylua
          yaml-language-server
          yamlfmt
        ];
        shellHook = ''
          nixfmt --version
        '';
      };
    };
}
