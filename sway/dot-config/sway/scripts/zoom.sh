TMP=$(mktemp)
grim -g "$(slurp)" - >"$TMP"
imv -u nearest_neighbour "$TMP"
rm "$TMP"
