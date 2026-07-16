gum log -l info "[START] transcrypt decryption"

cd ~/dotfiles/ || exit 1

VERIFY=1
STORED_HASH="4bf69f1718ef5130a05c4d01b363b1ca65ef92081449e24cc1d37fe7a9a07c69"

while true; do
    MASTER_PASSWORD=$(
        gum input --prompt "Master Password> " --password
    )
    COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
    if [ "$VERIFY" -eq 0 ]; then
        break
    fi
    if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
        gum log -l info "✅ Correct password"
        break
    else
        gum log -l error "❌ Wrong password, try again"
    fi
done

transcrypt -y -p "$MASTER_PASSWORD"

cd || exit 1

gum log -l info "[DONE] transcrypt decryption"
