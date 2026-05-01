#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# ------------- custom stuffs --------- 

# private ip
get_ip() {
  ip route get 1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}'
}

# subnet 
get_subnet() {
    local _ip=$(get_private_ip)
    # Finds the line containing the IP and extracts the specific network/mask
    ip -o addr show | awk -v ip="$_ip" '$0 ~ ip {print $4}'
}

# public ip 
saymyip() {
  curl -s https://icanhazip.com
}

# prompt
PS1='\[\e[1;32m\]\u@\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;37m\]❯\[\e[0m\] '

# ------------------------------------------------------

# echo "local : $(get_ip)" # local ip address 
# echo "subnet : $(get_subnet)" # subnet 
# echo "$(curl -s https://icanhazip.com)" # public ip - might consume time 


# PS1='\[\e[90m\]┌[\[\e[32m\]\W\[\e[90m\]]$(git branch 2>/dev/null | grep "*" | sed "s/* //" | xargs -I{} printf " \[\e[35m\]git:{}") \n\[\e[90m\]└\[\e[32m\]❯\[\e[0m\] '


# --- prompt : username@ip ---
get_prompt_ip() {
    local _ip=$(ip route get 1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}')
    echo "${_ip:-localhost}"
}

# This dynamically updates the prompt every time a command finishes
PROMPT_COMMAND='CURRENT_IP=$(get_prompt_ip)'

# Sets the prompt to: username@private_ip:working_dir$ 
PS1='\[\e[1;32m\]\u@$CURRENT_IP\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;37m\]❯\[\e[0m\] '
# PS1='\[\e[1;32m\]\u@$CURRENT_IP\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '