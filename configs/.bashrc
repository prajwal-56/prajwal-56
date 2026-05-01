#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# private ip
get_ip() {
  ip route get 1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}'
}

get_subnet() {
    local _ip=$(get_private_ip)
    # Finds the line containing the IP and extracts the specific network/mask
    ip -o addr show | awk -v ip="$_ip" '$0 ~ ip {print $4}'
}

PS1='\[\e[1;32m\]\u@\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\n\[\e[1;37m\]❯\[\e[0m\] '

localIp=$(get_ip)

echo "local : $localIp"
echo "subnet: $(get_subnet)
# PS1='\[\e[90m\]┌[\[\e[32m\]\W\[\e[90m\]]$(git branch 2>/dev/null | grep "*" | sed "s/* //" | xargs -I{} printf " \[\e[35m\]git:{}") \n\[\e[90m\]└\[\e[32m\]❯\[\e[0m\] '

