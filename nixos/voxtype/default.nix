{ ... }:
{
  services.voxtype = {
    enable = true;
    loadModels = [ "tiny.en" ];
    wayland.display = "wayland-1";
    settings = {
      hotkey.enabled = false;
      engine = "whisper";
      audio = {
        device = "default";
        sample_rate = 16000;
        max_duration_secs = 120;
      };
      whisper = {
        model = "tiny.en";
        language = "en";
        translate = false;
      };
      output = {
        mode = "type";
        fallback_to_clipboard = true;
        notification = {
          on_recording_start = false;
          on_recording_stop = false;
          on_transcription = false;
        };
      };
    };
  };
}
