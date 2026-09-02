{ pkgs, ... }:
{
  home.packages = with pkgs; [ jqp ];
  home.file.".jqp.yaml".source = ./jqp.yaml;
}
