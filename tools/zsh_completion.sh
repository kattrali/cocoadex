# Cocoadex completion function for Z Shell
# Append to ~/.zshrc

_cocoadex() {
    local cocoa_prefix
    read -l cocoa_prefix
    reply=(`cdex_completion "$cocoa_prefix"`)
}

compctl -K _cocoadex cocoadex