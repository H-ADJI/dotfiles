{
  programs.direnv = {
    nix-direnv.enable = true;
    enableZshIntegration = false;
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
