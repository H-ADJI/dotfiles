{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "khalil hadji";
        email = "h-adji_tech@proton.me";
      };
      alias.yolo = "!git add -A && git commit -m \"$(curl --silent --fail https://whatthecommit.com/index.txt)\"";
      alias.ga = "add";
      alias.gaa = "add --all";
      alias.gst = "status";
      alias.gc = "commit -v";
      alias.gcmsg = "commit -m";
      alias.gco = "checkout";
      alias.gcb = "checkout -b";
      alias.gb = "branch";
      alias.gl = "pull";
      alias.gp = "push";
      alias.glgg = "log --graph --oneline --decorate";
      alias.gd = "diff";
      alias.gds = "diff --staged";
      alias.grh = "reset --hard";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };
}
