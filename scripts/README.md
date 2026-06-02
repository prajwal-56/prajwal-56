# My Scripts 

## Claude Desktop App open on key stroke
- [open claude desktop app (linux)](claude-focus) - The script looks checks if there's any active **Claude Desktop running** and focuses on that. if not , it just starts a new instance by `claude-desktop`
    - This requires `wmctrl` to be installed.
    - Install wmctrl with  (on Arch Linux) :
        ```bash
        sudo pacman -S wmctrl
        ```
    - Make the script trigger when a key is pressed or something like that
    This works on my Arch + KDE Plasma 6 Machine btw