{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr.ratio = [ 0 1 1 ];
      preview = {
        max_height = 900;
        max_width = 1200;
        image_quality = 90;
        image_filter = "lanczos3";
      };
    };
    keymap.mgr.prepend_keymap = [
      {
        on = [ "y" ];
        run = [
          "shell -- for path in %s; do echo \"file://$path\"; done | pbcopy"
          "yank"
        ];
      }
    ];
  };
}
