# TODO: adapt with new spotify launcher and spicetify config
gum log -l info "[START] Spotify file permissions"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
gum log -l info "[DONE] Spotify file permissions"
gum log -l info "Downloading Spicetify"
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
gum log -l info "Applying Spicetify"
spicetify backup apply
spicetify update
spicetify apply
gum log -l info "[DONE] Spicetify"
rm install.log
