{ lib, ... }: {
  programs.mise = {
    enable = false;
    globalConfig.settings = {
      idiomatic_version_file_enable_tools = [
        "node"
        "python"
      ];
      trusted_config_paths = [
        "~/PDE/"
        "~/projects/neurogenesis/"
      ];
      env_file = ".env";
      activate_aggressive = true;
      lockfile = true;
    };
  };
}
