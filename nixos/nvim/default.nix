{
  config,
  pkgs,
  nixosModules,
  ...
}:

let
  nvim_lazy_conf = "${nixosModules}/nvim/config";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvim_lazy_conf;

  home.packages = with pkgs; [
    clang-tools
    deno
    gcc
    gnumake
    taplo
    tinymist
    tree-sitter
    vscode-langservers-extracted
  ];
}
