{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.lix;
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; };  # weekly on Sunday
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix-homebrew = {
    enable = true;
    user = "khalil";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    casks = [ "ghostty" ];
  };

  users.users.khalil = {
    home = "/Users/khalil";
    shell = pkgs.zsh;
  };

  system.primaryUser = "khalil";
  networking.hostName = "khalils-MacBook-Pro";

  programs.zsh.enable = true;

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    "com.apple.swipescrolldirection" = false;
    "com.apple.mouse.tapBehavior" = 1;
    AppleEnableSwipeNavigateWithScrolls = false;
    AppleEnableMouseSwipeNavigateWithScrolls = false;
    AppleKeyboardUIMode = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticInlinePredictionEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadRightClick = true;
    TrackpadThreeFingerHorizSwipeGesture = 0;
    TrackpadThreeFingerVertSwipeGesture = 0;
    TrackpadFourFingerHorizSwipeGesture = 0;
    TrackpadFourFingerVertSwipeGesture = 0;
    TrackpadFourFingerPinchGesture = 0;
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
    TrackpadPinch = true;
  };
  system.defaults.CustomUserPreferences = {
    "com.apple.AppleMultitouchTrackpad" = {
      TrackpadFiveFingerPinchGesture = 0;
    };
    NSGlobalDomain = {
      AppleCursorHiddenWhileTyping = true;
    };
  };
  system.defaults.dock = {
    autohide = true;
    orientation = "bottom";
    launchanim = false;
    minimize-to-application = true;
    mru-spaces = false;
    show-recents = false;
    static-only = true;
    showAppExposeGestureEnabled = false;
    showDesktopGestureEnabled = false;
    showLaunchpadGestureEnabled = false;
    showMissionControlGestureEnabled = false;
  };
  system.defaults.finder = {
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;
    CreateDesktop = false;
    FXDefaultSearchScope = "SCcf";
    FXPreferredViewStyle = "Nlsv";
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXSortFoldersFirst = true;
  };
  system.keyboard.enableKeyMapping = true;

  system.stateVersion = 6;
}
