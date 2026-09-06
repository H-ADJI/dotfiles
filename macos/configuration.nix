{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = "aarch64-darwin";
  };

  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  nix-homebrew = {
    enable = true;
    user = "khalil";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "opensuperwhisper"
      "raycast"
      "homerow"
    ];
  };

  users.users.khalil = {
    home = "/Users/khalil";
    shell = pkgs.zsh;
  };

  system = {
    defaults = {
      CustomUserPreferences = {
        "com.apple.AppleMultitouchTrackpad" = {
          TrackpadFiveFingerPinchGesture = 0;
        };
        "com.apple.screencapture" = {
          disable-shadow = true;
          location = "~/Desktop/Screenshots";
          type = "png";
        };
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            "28" = {
              enabled = false;
            };
            "30" = {
              enabled = false;
            };
            "34" = {
              enabled = false;
            };
            "60" = {
              enabled = false;
            };
            "61" = {
              enabled = false;
            };
            "63" = {
              enabled = false;
            };
            "64" = {
              enabled = false;
            };
          };
        };
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        AppleEnableSwipeNavigateWithScrolls = false;
        AppleKeyboardUIMode = 2;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.swipescrolldirection" = false;
      };
      spaces = {
        spans-displays = true;
      };
      dock = {
        autohide = true;
        launchanim = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        show-recents = false;
        showAppExposeGestureEnabled = false;
        showDesktopGestureEnabled = false;
        showLaunchpadGestureEnabled = false;
        showMissionControlGestureEnabled = false;
        static-only = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXSortFoldersFirst = true;
      };
      loginwindow = {
        GuestEnabled = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadFourFingerHorizSwipeGesture = 0;
        TrackpadFourFingerPinchGesture = 0;
        TrackpadFourFingerVertSwipeGesture = 0;
        TrackpadPinch = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerVertSwipeGesture = 0;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
    primaryUser = "khalil";
    stateVersion = 6;
  };

  system.activationScripts.postActivation.text = ''
    /usr/bin/defaults write com.apple.WindowManager StandardHideWidgets -bool true
  '';
}
