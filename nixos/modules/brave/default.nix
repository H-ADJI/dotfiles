{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    commandLineArgs = [
      "--disable-features=AIChat,BraveVPN"
    ];

    extraOpts = {
      # Disable Brave features
      BraveAIChatEnabled = false;
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveNewsDisabled = true;
      BravePlaylistEnabled = false;
      BraveSyncEnabled = false;
      BraveWaybackMachineEnabled = false;
      TorDisabled = true;

      # Disable telemetry
      BraveP3AEnabled = false;
      BraveStatsPingEnabled = false;
      MetricsReportingEnabled = false;
      CloudReportingEnabled = false;
      AutomaticallySendAnalytics = false;

      # Privacy
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      DefaultGeolocationSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultSensorsSetting = 2;
      BrowserGuestModeEnabled = false;
      BrowserSignin = 0;
      SyncDisabled = true;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "en-US" ];
    };
  };
}
