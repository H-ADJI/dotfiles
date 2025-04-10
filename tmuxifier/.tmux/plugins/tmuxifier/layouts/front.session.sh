# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
#session_root "~/Projects/front"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "front"; then

  window_root "~/tictac-vanilla/"
  new_window "coding"
  run_cmd "nv"

  window_root "~/tic-tac-toe-subscriber-refactor/"
  new_window "reference"
  run_cmd "nv"

  select_window 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
