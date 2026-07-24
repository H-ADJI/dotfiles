{ sops-nix, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/Users/khalil/.config/sops/age/keys.txt";

    secrets = {
      ssh_git = { path = "~/.ssh/ssh_git"; mode = "0600"; };
      work_github = { path = "~/.ssh/work_github"; mode = "0600"; };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = [
      {
        host = "github.com";
        identityFile = [ "~/.ssh/ssh_git" ];
      }
      {
        host = "work_github";
        hostname = "github.com";
        identityFile = [ "~/.ssh/work_github" ];
      }
    ];
    extraConfig = "Include /Users/khalil/.colima/ssh_config";
  };
}
