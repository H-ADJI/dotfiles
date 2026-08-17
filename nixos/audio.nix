{
  musnix.enable = true;
  musnix.kernel.realtime = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;

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

  users.users.khalil.extraGroups = [ "audio" ];
  security.rtkit.enable = true;
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

  services.power-profiles-daemon.enable = false;
  programs.gamemode.enable = true;

}
