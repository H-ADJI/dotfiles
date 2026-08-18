{ pkgs, ... }:
{
  # https://devenv.sh/languages/
  languages = {
    nix = {
      enable = true;
      lsp.package = pkgs.nil; # NOTE: default is nixd
    };
  };
  packages = with pkgs; [
    nixfmt
  ];
  enterShell = ''
    nixfmt --version
    nil --version
  '';
}
