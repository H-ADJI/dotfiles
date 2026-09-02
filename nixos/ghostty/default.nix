{ ... }:
{
  # nixos-specific: disable ligatures (macos keeps the default)
  programs.ghostty.settings.font-feature = "-liga,-calt";
}
