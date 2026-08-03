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
    asm-lsp
    asmfmt
    bash-language-server
    beautysh
    biome
    clang-tools
    deno
    dockerfile-language-server
    dockerfmt
    fish-lsp
    gcc
    gnumake
    go-tools
    gofumpt
    golines
    gopls
    harper
    iferr
    jq-lsp
    just-lsp
    kdlfmt
    lua-language-server
    markdownlint-cli2
    marksman
    nixfmt
    prettierd
    prettypst
    pyright
    ruff
    rust-analyzer
    shellcheck
    shfmt
    statix
    stylua
    taplo
    tinymist
    tree-sitter
    typescript-go
    typescript-language-server
    typst
    vscode-langservers-extracted
  ];
}
