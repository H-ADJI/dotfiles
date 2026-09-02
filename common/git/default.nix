{
  programs = {
    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "khalil hadji";
          email = "h-adji_tech@proton.me";
        };
        alias.yolo = "!git add -A && git commit -m \"$(curl --silent --fail https://whatthecommit.com/index.txt)\"";
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
  };
}
