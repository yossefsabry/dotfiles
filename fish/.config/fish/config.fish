### =========================
###  Fish config (fixed)
### =========================

# --- Print date/day banner ---
set -l cols (tput cols 2>/dev/null; or echo 80)
printf "\n\e[48;2;67;126;145m\e[38;2;234;242;244m%-*s\e[0m\n" \
  $cols "  "(date '+%A %m/%d/%Y %I:%M %p')


fish_config theme choose "Rosé Pine"

# --- PATH setup ---
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $HOME/.opencode/bin
fish_add_path -g $HOME/.bun/bin
fish_add_path -g $HOME/go/bin

function opencode
    $HOME/.opencode/bin/opencode $argv
end

# add all subfolders in ~/dotfiles/scripts
if test -d "$HOME/dotfiles/scripts"
    for d in (find "$HOME/dotfiles/scripts" -type d 2>/dev/null)
        fish_add_path -g $d
    end
end

# --- Env vars ---
set -gx brave "brave --password-store=basic"
set -gx GTK_THEME Arc-Dark
set -gx GTK_APPLICATION_PREFER_DARK_THEME 1
set -gx term kitty

# Go
set -gx GOROOT /usr/local/go
fish_add_path -g $GOROOT/bin
set -gx GOPATH $HOME/go
set -gx GOBIN $GOPATH/bin
fish_add_path -g $GOBIN

# Android
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
fish_add_path -g $ANDROID_HOME/emulator
fish_add_path -g $ANDROID_HOME/platform-tools
set -gx QT_QPA_PLATFORM xcb

# bun
set -gx BUN_INSTALL $HOME/.bun

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# fzf opts
set -gx FZF_DEFAULT_OPTS "--extended --layout=reverse --height=100% "

# Editor selection (SSH vs local)
if set -q SSH_CONNECTION
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end

# --- Aliases ---
alias hyprland "Hyprland"
alias nano "vim"
alias gpt "tgpt"
alias wine64 "wine"
alias wine32 "wine"
alias mpv "mpv --vf='scale=854:480'"

# making a lot of problems when clear the screen tmux
# alias tmux "env TERM=screen-256color-bce tmux"

alias ncmpcpp "ncmpcpp -b ~/.config/ncmpcpp/bindings"

alias vim "nvim"
alias v "nvim"
alias vi "/usr/bin/vim"
alias lutris "env GTK_THEME=Adwaita:dark lutris"

alias da "date \"+%Y-%m-%d %A %T %Z\""
alias clock "tty-clock -s -c -C 4"

alias mkdir "mkdir -p"
alias rm "rm -rf"

alias pc "xsel --input --clipboard"
alias pp "xsel --output --clipboard"
alias wpc "wl-copy"
alias wpp "wl-paste"

alias ping "ping -c 10"
alias less "less -R"

alias cd.. "cd .."
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

alias cdv "cd /home/$USER/.config/nvim"
alias notes "cd /home/$USER/notes"
alias dotfiles "cd /home/$USER/dotfiles"
alias scripts "cd /home/$USER/dotfiles/scripts"

alias la "ls -AFlh"
alias ls "ls --file-type -ah --color=always"
alias lsz "ls -lSrh"
alias lc "ls -lcrh"
alias lu "ls -lurh"
alias lt "ls -ltrh"
alias lm "sh -c 'ls -alh | more'"
alias lw "ls -xAh"
alias ll "ls -Fls"
alias labc "ls -lap"
alias lf "sh -c \"ls -l | egrep -v '^d'\""
alias ldir "sh -c \"ls -l | egrep '^d'\""


# for tmux rename session
function rs
    tmux rename-session -t (tmux display-message -p "#S") $argv
end

# for tmux kill-server
function ks
    if not set -q TMUX
        echo "Not inside tmux"
        return 1
    end
    tmux kill-server
end

# better grep helpers as functions (so argv works correctly)
function lsg --description "ls | grep <pattern>"
    ls | grep -- $argv
end

function h --description "history | grep <pattern>"
    history | grep -- $argv
end

function p --description "ps aux | grep <pattern>"
    ps aux | grep -- $argv
end

function f --description "find . | grep <pattern>"
    find . | grep -- $argv
end

alias google "ping google.com"
alias ipconfig "ifconfig"

alias diskspace "sh -c 'du -S | sort -n -r | more'"
alias folders "du -h --max-depth=1"
alias tree "tree -CAhF --dirsfirst"
alias treed "tree -CAFd"
alias mountedinfo "df -hT"
alias tmem "ps -eo pid,user,comm,%mem,%cpu --sort=-%mem | head -10"

alias mktar "tar -cvf"
alias mkbz2 "tar -cvjf"
alias mkgz "tar -cvzf"
alias untar "tar -xvf"
alias unbz2 "tar -xvjf"
alias ungz "tar -xvzf"

# --- FIXED logs (function, no fish $ expansion problems) ---
function logs --description "Tail all text logs under /var/log"
    sudo find /var/log -type f -exec file {} \; \
    | grep 'text' \
    | cut -d' ' -f1 \
    | sed -e 's/:\$//g' \
    | grep -v '[0-9]$' \
    | xargs tail -f
end

# --- fzf_cd ---
function fzf_cd --description "Pick a directory with fzf and cd into it"
    set -l folder (find (pwd) -type d -print 2>/dev/null | fzf --height 40%)
    if test -n "$folder"
        cd "$folder"
    else
        echo "No folder selected." >&2
        return 1
    end
end
alias fcd "fzf_cd"

# --- Key bindings / shortcuts ---
function __ctrl_f_tmux
    commandline -i "tm"
    commandline -f execute
end
bind \cf __ctrl_f_tmux

bind \er history-search-backward

# vim key
function fish_vi_cursor
    switch $fish_bind_mode
        case default
            printf '\e[5 q'   # blinking bar (insert)
        case insert
            printf '\e[5 q'
        case replace_one
            printf '\e[3 q'   # underline
        case visual
            printf '\e[1 q'   # block
        case '*'
            printf '\e[1 q'   # block (normal)
    end
end

function fish_bind_mode --on-variable fish_bind_mode
    fish_vi_cursor
end


# --------------------------------------------------
# Clipboard helper (Wayland / X11 auto-detect)
# --------------------------------------------------
function __clip_copy --description "Copy stdin to system clipboard (Wayland/X11)"
    # Prefer Wayland if available
    if test -n "$WAYLAND_DISPLAY"; or test -S /run/user/(id -u)/wayland-0
        if type -q wl-copy
            wl-copy
            return 0
        end
    end

    # Fallback to X11
    if type -q xclip
        xclip -selection clipboard
        return 0
    else if type -q xsel
        xsel --input --clipboard
        return 0
    end

    echo "No clipboard tool found. Install wl-clipboard (Wayland) or xclip/xsel (X11)." >&2
    return 1
end

# --------------------------------------------------
# Vim keybindings (yy copies whole command line)
# --------------------------------------------------
function fish_user_key_bindings
    # Enable vim mode
    fish_vi_key_bindings

    # Normal mode: yy → copy entire command line to system clipboard
    bind -M default yy 'commandline | __clip_copy'
end



starship init fish | source

