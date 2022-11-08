USR="$(whoami 2>/dev/null;)"
[ -z "$USR" ] && USR="($UID)";
export PS1="$USR@\H:\w\$ ";