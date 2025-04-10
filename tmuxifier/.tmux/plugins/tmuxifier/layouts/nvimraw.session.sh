if initialize_session "nvimraw"; then
  window_root "~/.config/nvimraw/"
  new_window "edit config"
  run_cmd "nv"
  new_window "test config"
  window_root "~/.config/nvimraw/"
  run_cmd "NVIM_APPNAME=nvimraw nv"
  select_window 1
fi

finalize_and_go_to_session
