#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  welcome.sh  ·  Live Terminal Dashboard for Prajwal (v2.1 Scroll-Proof)
# ─────────────────────────────────────────────────────────────────────────────

# ── 1. Configuration & Colors ─────────────────────────────────────────────────
ART_FILE="/home/prawmatheon/playground/prajwal-56/configs/asciiArt/godCreatingAdam"
NET_STATE_FILE="/dev/shm/prajwal_net_status"

R='\033[0m'          # reset
DIM='\033[2m'
BOLD='\033[1m'
WHITE='\033[38;5;255m'
CYAN='\033[38;5;117m'
SOFT='\033[38;5;244m'
GREEN='\033[38;5;114m' # For online status
GRAY='\033[38;5;240m'  # For offline status

# ── 2. Random Greeting ────────────────────────────────────────────────────────
greetings=(
    "Still writing C at ungodly hours?"
    "Namespaces, cgroups, or both today?"
    "Good to see you. Let's break something."
    "Another day, another segfault."
    "The shell is yours. Do something cursed."
    "Systems programming: where real ones live."
)
GREETING="${greetings[$RANDOM % ${#greetings[@]}]}"

# ── 3. Static Info Gatherers ──────────────────────────────────────────────────
IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || hostname -I 2>/dev/null | awk '{print $1}')
IP=${IP:-"Offline"}
KERN=$(uname -r)
DATE_STR=$(date '+%A, %B %d  ·  %H:%M')

# ── 4. The Background Internet Checker (Silenced) ─────────────────────────────
(
    while true; do
        if ping -c 1 -W 1 1.1.1.1 &>/dev/null; then
            echo "ONLINE" > "$NET_STATE_FILE"
        else
            echo "OFFLINE" > "$NET_STATE_FILE"
        fi
        sleep 2
    done
) &
PING_PID=$!
disown $PING_PID # Removes it from Bash job control so it dies quietly

# The Trap ensures everything cleans up cleanly when the script closes
cleanup() {
    kill -9 $PING_PID 2>/dev/null
    rm -f "$NET_STATE_FILE"
    tput cnorm  # Bring back the blinking cursor
    clear       # Clear the screen to give you your terminal
}
trap cleanup EXIT SIGINT SIGTERM

# ── 5. CPU Calc Setup ─────────────────────────────────────────────────────────
read -r _ user nice sys idle _ < /proc/stat
PREV_IDLE=$idle
PREV_TOTAL=$((user+nice+sys+idle))
CPU_USAGE="0%"

# ── 6. Prepare the Terminal & Print STATIC Top Half ───────────────────────────
tput civis   # Hide the blinking cursor
clear        # Clear screen ONCE

echo -e "${CYAN}"
cat "$ART_FILE" 2>/dev/null
echo -e "${R}"

printf "  ${SOFT}${DATE_STR}${R}\n"
printf "  ${BOLD}${WHITE}${GREETING}${R}\n\n"

LINE="  ${SOFT}──────────────────────────────────────────${R}"
echo -e "$LINE"

printf "  ${CYAN}%-12s${R}  ${WHITE}%s${R}\n" "󰒍 local ip" "$IP"

# ── 7. The Bulletproof Live Render Loop ───────────────────────────────────────
FIRST_RUN=1

while true; do
    # If it's NOT the first run, we move the cursor UP exactly 8 lines 
    # to overwrite the previous stats block.
    if [ $FIRST_RUN -eq 1 ]; then
        FIRST_RUN=0
    else
        printf "\033[8A" 
    fi

    # -- Calculate live CPU --
    read -r _ user nice sys idle _ < /proc/stat
    TOTAL=$((user+nice+sys+idle))
    DIFF_IDLE=$((idle-PREV_IDLE))
    DIFF_TOTAL=$((TOTAL-PREV_TOTAL))
    if [ $DIFF_TOTAL -gt 0 ]; then
        CPU_USAGE="$((100 * (DIFF_TOTAL - DIFF_IDLE) / DIFF_TOTAL))%"
    fi
    PREV_IDLE=$idle; PREV_TOTAL=$TOTAL

    # -- Calculate live RAM --
    RAM=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%.1f / %.1f GB", (t-a)/1024/1024, t/1024/1024}' /proc/meminfo)

    # -- Read live Internet --
    NET_STAT=$(cat "$NET_STATE_FILE" 2>/dev/null)
    if [ "$NET_STAT" == "ONLINE" ]; then
        NET_COLOR=$GREEN
        NET_TEXT="󰤨 Connected"
    elif [ "$NET_STAT" == "OFFLINE" ]; then
        NET_COLOR=$GRAY
        NET_TEXT="󰤭 Offline"
    else
        NET_COLOR=$SOFT
        NET_TEXT="󰤩 Checking..."
    fi

    # -- Draw ONLY the Dynamic Stats (Exactly 8 Lines) --
    # \033[K ensures that the entire line is cleared before writing, fixing ghost characters
    printf "  ${CYAN}%-12s${R}  ${WHITE}%-20s${R}\033[K\n"     "󰘚 cpu"      "$CPU_USAGE"
    printf "  ${CYAN}%-12s${R}  ${WHITE}%-20s${R}\033[K\n"     "󰍛 ram"      "$RAM"
    printf "  ${CYAN}%-12s${R}  ${NET_COLOR}%-20s${R}\033[K\n" "󰤨 internet" "$NET_TEXT"

    echo -e "$LINE\033[K"
    
    printf "  ${SOFT}%-12s${R}  ${DIM}%s${R}\033[K\n" " kernel"   "$KERN"

    echo -e "$LINE\033[K\n"
    printf "  ${DIM}Press any key to drop to shell...${R}\033[K\n" 

    # -- Wait for Keypress --
    read -t 0.5 -n 1 -s key
    if [ $? -eq 0 ]; then
        break 
    fi
done