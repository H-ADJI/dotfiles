{
  config,
  lib,
  ...
}:
{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };
    settings = {
      config-version = 2;

      start-at-login = true;

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${lib.getExe config.programs.sketchybar.finalPackage} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      gaps = {
        inner = {
          horizontal = 30;
          vertical = 30;
        };
        outer = {
          left = 30;
          bottom = 30;
          top = 64;
          right = 30;
        };
      };

      automatically-unhide-macos-hidden-apps = false;

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      on-focus-changed = [ "move-mouse window-lazy-center" ];

      persistent-workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
      ];

      key-mapping.preset = "qwerty";

      on-window-detected = [
        {
          "if".app-id = "com.apple.Preview";
          run = "layout floating";
        }
      ];

      mode = {
        main.binding = {
          # Focus direction (Alt, like Aerospace default — no macOS conflicts)
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-left = "focus left";
          alt-down = "focus down";
          alt-up = "focus up";
          alt-right = "focus right";

          # Move window
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # Layout
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # Resize
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          # Workspace switching (Alt — all actions use the same modifier)
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";

          # Move window to workspace
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 10";

          # Workspace back-and-forth
          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

          # Actions
          alt-f = "fullscreen";
          alt-shift-r = "reload-config";
          alt-shift-f = "layout floating tiling";
          alt-q = "close";

          # Launch apps (new window via -n flag)
          alt-space = "exec-and-forget open -n -b com.mitchellh.ghostty";
          alt-shift-s = "exec-and-forget open -b com.apple.systempreferences";
          alt-b = "exec-and-forget open -n -b com.brave.Browser";

          # Screenshots (save + open in Preview for annotation)
          alt-c = "exec-and-forget screencapture /tmp/screenshot.png && open -a Preview /tmp/screenshot.png";
          alt-shift-c = "exec-and-forget screencapture -i /tmp/screenshot.png && open -a Preview /tmp/screenshot.png";

          # Enter service mode for advanced ops
          alt-shift-semicolon = "mode service";

          # Enter resize mode
          alt-r = "mode resize";
        };
        service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];
          alt-shift-h = [
            "join-with left"
            "mode main"
          ];
          alt-shift-j = [
            "join-with down"
            "mode main"
          ];
          alt-shift-k = [
            "join-with up"
            "mode main"
          ];
          alt-shift-l = [
            "join-with right"
            "mode main"
          ];
        };
        resize.binding = {
          h = "resize width -50";
          j = "resize height +50";
          k = "resize height -50";
          l = "resize width +50";
          enter = "mode main";
          esc = "mode main";
        };
      };
    };
  };
}
