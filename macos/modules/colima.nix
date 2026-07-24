{ lib, pkgs, ... }:

{
  services.colima.enable = true;

  # Colima needs gzip while unpacking its initial VM image. The upstream
  # LaunchAgent PATH omits macOS's /usr/bin, where gzip is provided.
  launchd.agents.colima-default.config.EnvironmentVariables.PATH = lib.mkForce
    "${pkgs.colima}/bin:${pkgs.perl}/bin:${pkgs.docker}/bin:${pkgs.openssh}/bin:${pkgs.coreutils}/bin:${pkgs.curl}/bin:${pkgs.bashNonInteractive}/bin:${pkgs.kubectl}/bin:${pkgs.darwin.DarwinTools}/bin:/usr/bin:/bin";
}
