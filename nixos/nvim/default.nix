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
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      biome
      clang-tools
      deno
      gcc
      gnumake
      marksman
      harper
      typescript-go
      lua-language-server
      neovim
      nixd
      nixfmt
      nodejs
      prettierd
      statix
      stylua
      taplo
      tinymist
      tree-sitter
      vscode-langservers-extracted
      yaml-language-server
      yamlfmt
    ];
  };
}
