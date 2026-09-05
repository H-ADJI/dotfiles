{
  programs.direnv = {
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enable = true;
    silent = true;
    config = {
      whitelist = {
        prefix = [
          "~/PDE/"
          "~/projects/"
        ];
      };
    };
  };
}
