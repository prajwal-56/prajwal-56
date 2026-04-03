#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  welcome.sh  ·  Terminal welcome banner for Prajwal
#  Drop this anywhere (e.g. ~/.config/welcome.sh) and source it from ~/.zshrc
# ─────────────────────────────────────────────────────────────────────────────

# ── ANSI color shortcuts ──────────────────────────────────────────────────────
R='\033[0m'          # reset
DIM='\033[2m'
BOLD='\033[1m'
GOLD='\033[38;5;220m'
ORANGE='\033[38;5;208m'
SOFT='\033[38;5;244m'
WHITE='\033[38;5;255m'
CYAN='\033[38;5;117m'
GREEN='\033[38;5;114m'
RED='\033[38;5;203m'
BLUE='\033[38;5;111m'

# ── Random greeting pool ──────────────────────────────────────────────────────
greetings=(
    "Still writing C at ungodly hours?"
    "Namespaces, cgroups, or both today?"
    "Good to see you. Let's break something."
    "Ready to poke the kernel again?"
    "Another day, another segfault."
    "What are we building today?"
    "The shell is yours. Do something cursed."
    "No bugs. Only undocumented features."
    "Back again. The terminal missed you."
    "Let's get weird with syscalls."
    "What's the plan — pwn or build?"
    "Fork. Exec. Repeat."
    "chmod 777 your ambitions."
    "Make it compile. Make it cool."
    "Systems programming: where real ones live."
)
GREETING="${greetings[$RANDOM % ${#greetings[@]}]}"

# ── System info collectors ────────────────────────────────────────────────────
get_local_ip() {
    ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' \
    || hostname -I 2>/dev/null | awk '{print $1}' \
    || echo "—"
}

get_cpu_usage() {
    # read two snapshots 0.3s apart for accuracy
    local cpu1 cpu2
    read -r _ user1 nice1 sys1 idle1 _ < /proc/stat
    sleep 0.3
    read -r _ user2 nice2 sys2 idle2 _ < /proc/stat
    local used=$(( (user2+nice2+sys2) - (user1+nice1+sys1) ))
    local total=$(( used + (idle2 - idle1) ))
    printf "%d%%" $(( total > 0 ? used*100/total : 0 ))
}

get_ram_usage() {
    awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{
        used=(t-a)/1024/1024
        total=t/1024/1024
        printf "%.1f / %.1f GB", used, total
    }' /proc/meminfo
}

get_disk_usage() {
    df -h / 2>/dev/null | awk 'NR==2{printf "%s used / %s total", $3, $2}'
}

get_uptime() {
    uptime -p 2>/dev/null | sed 's/up //' || echo "—"
}

get_kernel() {
    uname -r
}

get_shell_version() {
    $SHELL --version 2>/dev/null | head -1 | awk '{print $1, $2}' || echo "$SHELL"
}

get_package_count() {
    if command -v rpm &>/dev/null; then
        rpm -qa --quiet 2>/dev/null | wc -l
    elif command -v dpkg &>/dev/null; then
        dpkg -l 2>/dev/null | grep -c '^ii'
    else
        echo "—"
    fi
}

# ── Print the banner ──────────────────────────────────────────────────────────
print_banner() {
    # Collect info (CPU takes ~0.3s, do first)
    local CPU; CPU=$(get_cpu_usage)
    local IP RAM DISK UP KERN SHELL_V PKGS DATE_STR
    IP=$(get_local_ip)
    RAM=$(get_ram_usage)
    DISK=$(get_disk_usage)
    UP=$(get_uptime)
    KERN=$(get_kernel)
    SHELL_V=$(get_shell_version)
    PKGS=$(get_package_count)
    DATE_STR=$(date '+%A, %B %d  ·  %H:%M')

    clear

    # ── ASCII Art: Creation of Adam ───────────────────────────────────────────
    echo
    printf "${GOLD}"
    cat << 'ASCIIART'
                                        ✦
          _________                  ✦     ✦                  _________
         /         \_______________✦           ✦_____________/         \
        |           |             ✦             ✦             |         |
        |  A D A M  |______________✦           ✦______________|  G O D  |
         \_________/                ✦         ✦                \_________/
          |  ~ ~ ~  |                ✦       ✦                 |  ~ ~ ~  |
          |_________|                  ✦   ✦                   |_________|
                                         ✦
                          · · · T H E   S P A R K · · ·
ASCIIART
    printf "${R}\n"

    # ── Date & greeting ──────────────────────────────────────────────────────
    printf "  ${SOFT}${DATE_STR}${R}\n"
    printf "  ${BOLD}${WHITE}${GREETING}${R}\n"
    echo

    # ── Info panel ───────────────────────────────────────────────────────────
    local LINE="  ${SOFT}─────────────────────────────────────────────────${R}"
    echo -e "$LINE"

    printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n"  "󰒍 local ip"    "$IP"
    printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n"  " cpu"         "$CPU"
    printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n"  " ram"         "$RAM"
    printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n"  "󰋊 disk /"     "$DISK"
    printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n"  " uptime"     "$UP"

    echo -e "$LINE"

    printf "  ${SOFT}%-12s${R}  ${DIM}%s${R}\n"   " kernel"     "$KERN"
    printf "  ${SOFT}%-12s${R}  ${DIM}%s${R}\n"   " shell"      "$SHELL_V"
    printf "  ${SOFT}%-12s${R}  ${DIM}%s${R}\n"   "󰏖 packages"  "$PKGS"

    echo -e "$LINE"
    echo
    printf "  ${SOFT}${DIM}Press any key to continue...${R}\n"
    echo
}

# ── Clear-on-keypress hook for Zsh ───────────────────────────────────────────
_banner_clear_once() {
    # Only fires once; after that, restores normal bindings
    if [[ -n "$_BANNER_ACTIVE" ]]; then
        unset _BANNER_ACTIVE
        # Rebind all keys back to their defaults
        bindkey -e 2>/dev/null || bindkey -v 2>/dev/null
        # Clear the screen cleanly then redraw prompt
        tput cup 0 0
        tput ed
        zle reset-prompt 2>/dev/null
    fi
    # Pass the character through so it's not eaten
    zle self-insert 2>/dev/null
    return 0
}

_banner_clear_special() {
    if [[ -n "$_BANNER_ACTIVE" ]]; then
        unset _BANNER_ACTIVE
        bindkey -e 2>/dev/null || bindkey -v 2>/dev/null
        tput cup 0 0
        tput ed
        zle reset-prompt 2>/dev/null
    fi
}

# ── Entry point (called from .zshrc) ─────────────────────────────────────────
welcome_banner() {
    # Only show in interactive shells, skip inside tmux nested panes if desired
    [[ $- != *i* ]] && return

    print_banner

    if [[ -n "$ZSH_VERSION" ]]; then
        # Zsh: hook via ZLE (Zsh Line Editor)
        export _BANNER_ACTIVE=1
        zle -N _banner_clear_once
        zle -N _banner_clear_special

        # Bind printable chars + common specials to the clear widget
        for k in {a..z} {A..Z} {0..9}; do
            bindkey "$k" _banner_clear_once
        done
        # Space, punctuation
        for k in ' ' '.' ',' '/' '-' '_' '=' '+' '[' ']' '{' '}' \
                  '!' '@' '#' '$' '%' '^' '&' '*' '(' ')' \
                  '"' "'" '\' '|' '<' '>' '?' '`' '~' ';' ':'; do
            bindkey "$k" _banner_clear_once
        done
        bindkey '^?' _banner_clear_special  # backspace
        bindkey '^[' _banner_clear_special  # escape
        bindkey '^C' _banner_clear_special  # ctrl-c
        bindkey '^U' _banner_clear_special  # ctrl-u
        bindkey '^L' _banner_clear_special  # ctrl-l

    else
        # Bash fallback: block until any key, then clear
        IFS= read -r -s -n1 _key </dev/tty
        tput cup 0 0
        tput ed
    fi
}
