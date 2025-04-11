# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dotfiles"; then

    # Create a new window inline within session layout definition.
    window_root "~/dotfiles"
    new_window "dotfiles"

    window_root "~/cyborg/"
    new_window "cyborg"

    window_root "~/.dotfiles"
    new_window "old dotfiles"

    select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
