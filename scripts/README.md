# My Scripts 

small utility scripts i've written for my setup. feel free to steal.
 
---
 
### [claude-focus](claude-focus)
 
focuses the Claude Desktop window if it's already open, launches it if not.
 
Claude Desktop is an Electron app, so it doesn't have a predictable process name you can grep for. this script works around that by checking for the window title via `wmctrl` instead.
 
**dependencies**
 
```bash
sudo pacman -S wmctrl  # Arch
```
 
**setup**
 
```bash
# clone and symlink so it lives in your PATH
git clone https://github.com/prajwal-56/prajwal-56.git
sudo ln -s $(pwd)/prajwal-56/scripts/claude-focus /usr/local/bin/claude-focus
sudo chmod +x /usr/local/bin/claude-focus
```
 
then bind it to a keyboard shortcut in your DE. on KDE: System Settings → Shortcuts → Custom Shortcuts → new shortcut → command: `claude-focus`.
 
**note:** tested on Arch Linux + KDE Plasma 6 (Wayland). `wmctrl` only sees XWayland windows, but Claude Desktop runs via XWayland so it works fine.
