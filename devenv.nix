{ pkgs, ... }:
{
  # https://devenv.sh/languages/
  languages = {
    nix = {
      enable = true;
      lsp.package = pkgs.nixd; # NOTE: default is nixd
    };
  };
  packages = with pkgs; [
    nixfmt
    lua-language-server
    stylua
    yaml-language-server
    yamlfmt
  ];
  enterShell = ''
    nixfmt --version
    nil --version
  '';
}
