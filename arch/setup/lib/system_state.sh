gum log -l info "[START] Setting system state"

sudo usermod -aG docker "$USER"
sudo timedatectl set-timezone Europe/Paris
sudo systemctl enable --now iwd.service
sudo systemctl enable docker.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
systemctl --user enable --now hyprpolkitagent
which zsh | sudo tee -a /etc/shells
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/png
xdg-mime default google-chrome.desktop application/pdf
xdg-mime default google-chrome.desktop x-scheme-handler/https
xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop application/html
xdg-mime default google-chrome.desktop application/octet-stream

gum log -l info "[DONE] Setting system state"
