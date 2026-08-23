{ pkgs, lib, ... }:
{
  musnix = {
    enable = true;
    kernel.realtime = true;
  };

  services = {
    desktopManager.gnome.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;
    pipewire = {
      jack.enable = true;
      alsa.support32Bit = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 512;
        };
      };
      wireplumber.extraConfig."99-disable-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];

  boot.kernelParams = [
    "amd_pstate=active"
    "usbcore.autosuspend=-1"
  ];

  users.users.khalil = {
    extraGroups = [ "audio" ];
    packages = with pkgs; [
      ardour
      guitarix
      calf
      vim
      curl
      git
      neovim
      wget
    ];
  };
  programs = {
    gamemode.enable = true;
  };
}
