{ inputs, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;

  };

  musnix.enable = true;
  musnix.kernel.realtime = true;
}
