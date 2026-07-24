{ pkgs, ... }:

{
  home.packages = with pkgs; [ clipcat ];

  home.file = {
    ".config/clipcat/clipcatd.toml".text = ''
      [watcher]
      enable_clipboard = true

      [grpc]
      server_endpoint = "/tmp/clipcat.sock"

      [storage]
      max_history = 100
    '';

    ".config/clipcat/clipcat-menu.toml".text = ''
      server_endpoint = "/tmp/clipcat.sock"
      finder = "fzf"
    '';
  };
}
