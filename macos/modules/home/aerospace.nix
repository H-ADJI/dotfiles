{ pkgs, ... }:

{
  home.file.".aerospace.toml" = {
    source = ./aerospace/aerospace.toml;
  };
}
