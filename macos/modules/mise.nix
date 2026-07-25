{ ... }: {
  xdg.configFile."mise/config.toml".text = ''
    #:schema https://mise.jdx.dev/schema/mise.json

    [settings]
    idiomatic_version_file_enable_tools = ['node', "python"]
    trusted_config_paths = [
      "~/dotfiles/",
      "~/projects/neurogenesis/",
    ]
    env_file = '.env'
    activate_aggressive = true
    lockfile = true

    [tools]
    usage = "3.5.3"
    pi = "0.80.3"
    hunk = "0.16.0"
    opencode = "1.18.3"
  '';
}
