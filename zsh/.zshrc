# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

######## themes #########
 ZSH_THEME="robbyrussell"  #linuxonly
# starship theme
#eval "$(starship init zsh)"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
    vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
#
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# enable vim mode
bindkey -v

# Set KEYTIMEOUT to recognize key sequences faster
export KEYTIMEOUT=1

# for change to visual mode in vim
bindkey -M vicmd v edit-command-line
bindkey -M viins 'jk' vi-cmd-mode

# set default editor
export EDITOR=nvim
export VISUAL=nvim
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'
alias vim='nvim'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'
alias etmux='nvim ~/.tmux.conf'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# adding shourtcuts for bash
alias mkdir='mkdir -p'
alias rm='rm -rf'
alias cp='yes | cp -Ri'
alias pbcopy='xsel --input --clipboard' 
alias pbpaste='xsel --output --clipboard'
alias ebrc='nvim ~/.bashrc'
alias ezsh='nvim ~/.zshrc'
alias etmux='nvim ~/.tmux.conf'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'
alias removeNvimCache="rm -rf ~/.local/share/nvim/"
# for search in history
bindkey '\er' history-incremental-search-backward

# Change directory aliases
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdg="cd /home/$USER/projects/go-course"
alias cdc="cd /home/$USER/projects/c-projects"
alias cdv="cd /home/$USER/.config/nvim"
alias notes="cd /home/$USER/notes"
alias dotfiles="cd /home/$USER/dotfiles"
alias build="./build"
alias fz="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias gf="fzf --height=40% --bind 'enter:become(nvim {}),ctrl-e:become(vim {})'"
alias fcd="fzf_cd"


# Alias's for multiple directory listing commands
alias la='ls -AFlh' # show hidden files
alias ls='ls -ah --color=always' # add colors and file type extensions
alias lsg='ls -alfh --color=always | grep ' # add colors and file type extensions
alias lx='ls -lXBh' # sort by extension
alias lsz='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh' # wide listing format
alias ll='ls -Fls' # long listing format
alias labc='ls -lap' #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias lfa="ls -aFhl | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only


# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# net checking 
alias google="ping google.com"

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"


# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# tmux config
alias idv='tmux split-window -v -l 30% && tmux split-window -h -l 50% && tmux select-pane -t 0 '    # idw = i3 dev window
alias idh='tmux split-window -h -l 25% && tmux split-window -v -l 50% && tmux select-pane -t 0 '    # idw = i3 dev window


# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"


### auto jump command for zshrc
#if [ -f "/usr/share/autojump/autojump.sh" ]; then
#    . /usr/share/autojump/autojump.s 
#elif [ -f "/usr/share/autojump/autojump.bash" ]; then
#    . /usr/share/autojump/autojump.bash
#elif [ -f "/usr/share/autojump/autojump.zsh" ]; then
#    . /usr/share/autojump/autojump.basi
#else
#    echo "can't find the autojump script"
#fi



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


#go lang setup
export GOPATH="$HOME/go/bin"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"
export PATH="$PATH:$HOME/go/bin/"
export PATH=$PATH:/usr/local/go/bin


# ----- Function to search for a folder and create a new tmux session in that folder ------
tmux_new_session() {
  export FZF_DEFAULT_OPTS='--layout=reverse --height=40% '
  selected_dir=$(find ~ -type d 2>/dev/null | fzf)
  
  if [ -n "$selected_dir" ]; then
    session_name=$(basename "$selected_dir")
    
    if [ -n "$TMUX" ]; then
      # If inside an existing tmux session, offer to create a nested session
      printf "You are already in a tmux session. Do you want to create a nested session? (y/n) "
      read choice
      case "$choice" in 
        y|Y ) 
          tmux new-session -s "$session_name" -c "$selected_dir"
          ;;
        * ) 
          echo "Aborting nested tmux session creation."
          ;;
      esac
    else
      tmux new-session -s "$session_name" -c "$selected_dir"
      tmux attach-session -t "$session_name"
    fi
  fi
}
# Bind Alt+c to the tmux_new_session function
bindkey -s '^[c' 'tmux_new_session\n'
# ***** Function to search for a folder and create a new tmux session in that folder ******



# ----- Function to search for a folder and navigate to it using fzf -----
function fzf_cd() {
    # Find directories, use fzf to select one, and navigate to it
    local folder
    folder=$(find . -type d 2>/dev/null | fzf --height 40% --layout=reverse --border --preview 'tree -C {} | head -n 20')
    # Check if a folder was selected
    if [[ -n "$folder" ]]; then
        cd "$folder" || return
        # Display the structure of the selected folder
        # tree -C
    else
        echo "No folder selected." >&2
        return 1
    fi
}
# ***** Function to search for a folder and navigate to it using fzf *****

# --------- for the notes function shourtcuts ------------- 
# Function to add a new note
add_note() {
  # Ensure correct number of arguments
  if [ "$#" -ne 2 ]; then
    echo "Usage: add_note <folder> <name>"
    return 1
  fi
  local folder="$1"
  local name="$2"
  local notes_dir="$HOME/notes/$folder"
  local file_path="$notes_dir/$name.md"
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  # Create the directory if it does not exist
  if ! mkdir -p "$notes_dir"; then
    echo "Error: Unable to create directory $notes_dir"
    return 1
  fi
  # Check if the file already exists
  if [ -f "$file_path" ]; then
    echo "Error: File $file_path already exists"
    return 1
  fi
  # Create the markdown file with the template
  cat <<EOL > "$file_path"

<div style="padding: 5px 20px; display: block; marign: auto; font-family: sans;
2ont-size: 18px; line-height: 1.8; letter-spacing: 1.2px;">

># **title**: "$folder - $name.md"

\`\`\`
- **fileName**: $name
- **Created on**: $timestamp
\`\`\`

<!-- Your notes here -->

<!-- end notes here -->

</div>

**continue**:[[]]
**before**:[[]]

EOL
  # Check if the file was created successfully
  if [ ! -f "$file_path" ]; then
    echo "Error: Unable to create file $file_path"
    return 1
  fi
  # Open the file in Neovim
  nvim "$file_path"
}
# Define an alias for the add_note function
alias addnote='add_note'
# ********* for the notes function shourtcuts ************* 

# -------- for search in history -----------
fzf_history() {
  # Use fzf to search through the command history
  local cmd=$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | fzf --height=40%)
  # If a command is selected, execute it
  if [ -n "$cmd" ]; then
    eval $cmd
  fi
}
alias fh="fzf_history"
# ********* for search in history********* 


# ********* toogle touchpad -> disable and enable ******** 
toggle_touchpad() {
  # Dynamically find the touchpad device
  DEVICE_NAME=$(xinput list | grep -i 'TouchPad' | grep -o 'AlpsPS/2 ALPS DualPoint TouchPad')
  if [ -z "$DEVICE_NAME" ]; then
    echo "Touchpad not found!"
    return 1
  fi
  DEVICE_ID=$(xinput list --id-only "$DEVICE_NAME")
  if [ -z "$DEVICE_ID" ]; then
    echo "Touchpad ID not found!"
    return 1
  fi
  DEVICE_ENABLED=$(xinput list-props "$DEVICE_ID" | grep "Device Enabled" | grep -o "[01]$")
  if [ "$DEVICE_ENABLED" -eq 1 ]; then
    xinput disable "$DEVICE_ID"
    notify-send "Touchpad disabled"
  else
    xinput enable "$DEVICE_ID"
    notify-send "Touchpad enabled"
  fi
  unclutter -idle 0  #for hide the mouse
}
# Optionally, you can bind this function to a keyboard shortcut or call it directly
# ********* toogle touchpad -> disable and enable ******** 


nvim_checker() {
  # Prompt the user for the Neovim configuration choice
  echo "---- choose the config for nvim ----"
  echo "1- nvim-1 (first config split files-> default)"
  echo "2- nvim-2 (second config one file)"
  echo "3- nvim-3 (lazy custom config)"
  read -r option
  # Define the paths
  config_path="/home/$USER/.config/nvim"
  dotfiles_path="/home/$USER/dotfiles/nvims"
  # Remove any existing Neovim configuration directory
  if [ -d "$config_path" ]; then
    rm -rf "$config_path"
    echo "Existing Neovim configuration removed"
  fi
  # Create the symbolic link based on the user's choice
  case "${option}" in
    1) ln -svf "$dotfiles_path/nvim-1" "$config_path" ;;
    2) ln -svf "$dotfiles_path/nvim-2" "$config_path" ;;
    3) ln -svf "$dotfiles_path/nvim-3" "$config_path" ;;
    *) ln -svf "$dotfiles_path/nvim-1" "$config_path" ;;
  esac
}



# ------------- some info ---------
# alsamixer -> for change the sound level arch
#stow --adopt --ignore=background --ignore=dwm-config --ignore=nvim --ignore=mybash-config -> stow the dotfiles
# ------------- some info ---------
