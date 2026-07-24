{ sops-nix, config, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets.ssh_git = {
      path = "${config.home.homeDirectory}/.ssh/ssh_git";
      mode = "0600";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "yes";
      IdentityFile = "~/.ssh/ssh_git";
      StrictHostKeyChecking = "accept-new";
      UserKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
