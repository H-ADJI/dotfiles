{
  config,
  pkgs,
  nixosModules,
  ...
}:

let
  nvim_lazy_conf = "${nixosModules}/nvim/config";
  nvim_pack_conf = "${nixosModules}/nvim/packconfig";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvim_lazy_conf;
  xdg.configFile."nvimpack".source = config.lib.file.mkOutOfStoreSymlink nvim_pack_conf;

  home.packages = with pkgs; [
    neovim
    tree-sitter
    deno
    typst
    gcc
    lua-language-server
    asm-lsp
    just-lsp
    jq-lsp
    gopls
    rust-analyzer
    harper
    tinymist
    clang-tools
    ruff
    pyright
    bash-language-server
    marksman
    biome
    taplo
    dockerfile-language-server
    typescript-language-server
    vscode-langservers-extracted
    fish-lsp

    asmfmt
    iferr
    go-tools
    gofumpt
    golines
    prettypst
    prettierd
    dockerfmt
    shfmt
    stylua
    beautysh
    kdlfmt
    nixfmt

    markdownlint-cli2
    shellcheck
    statix
    typescript-go
  ];
}
