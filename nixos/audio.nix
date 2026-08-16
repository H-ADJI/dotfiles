{ inputs, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Required for yabridge/wine VST bridging
    wireplumber.enable = true;

  };

  musnix.enable = true;
  musnix.kernel.realtime = true;
}
