{ pkgs, ... }:

{
    xdg.configFile."nvim".source = ./config;

  home.packages = with pkgs; [
    neovim
    tree-sitter
    deno
    typst

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
