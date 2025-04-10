# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/.dotfiles/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dotfiles"; then

    # Create a new window inline within session layout definition.
    new_window "shell"

    window_root "~/.dotfiles/nvim/.config/nvim/"
    new_window "nvim config"
    run_cmd "nv"

    window_root "~/.dotfiles/zsh/"
    new_window "zsh config"
    run_cmd "nv"

    window_root "~/.dotfiles/ansible/"
    new_window "ansible playbooks"
    run_cmd "nv"

    window_root "~/cyborg/"
    new_window "cyborg"
    run_cmd "nv"

    select_window 1
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
