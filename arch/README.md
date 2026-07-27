# Arch BTW

Arch workstation configuration using :

- **archinstall** : system configuration and disk partitioning
- **stow** : dotfiles symlink farm management
- **bash scripts** : packages installation and set up

## Bootstrap

A single command (actually 2 commands) to set up my machine automagically :D.

**Arch Install Configuration**

```bash
archinstall --config-url https://hh9dj.github.io/PDE/arch/workstation.json
```

**Desktop Environment**

```bash
curl -fsSL hh9dj.github.io/PDE/arch/init.sh | bash
```
