# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin/:$PATH"
export PATH="$HOME/bin/:$PATH"
# for scripts dotfiles
# ====== adding all folders inside scripts folder =======
export PATH="$(find "$HOME/dotfiles/scripts" -type d | tr '\n' ':')$PATH"
# export PATH="$HOME/dotfiles/scripts:$PATH"
# export PATH="$HOME/dotfiles/scripts/install_scripts:$PATH"


alias gpt="tgpt "
alias wine64="wine "
alias wine32="wine "
#alias python="python3 "

# for slove loss colorscheme for nvim in tmux
alias tmux="TERM=screen-256color-bce tmux"


# alias for ncmpcppp for config for the new bindings file
alias ncmpcpp="ncmpcpp -b ~/.config/ncmpcpp/bindings"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

######## themes #########
 ZSH_THEME="robbyrussell"  #linuxonly
# starship theme
# eval "$(starship init zsh)"

# zoxide 
eval "$(zoxide init zsh)"

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
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

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

# set default editor
export term=kitty
alias browser=brave-browser
alias brave="brave-browser"
alias vim='nvim'
alias vi='/usr/bin/vim'
alias lutris='GTK_THEME=Adwaita:dark lutris'


# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'
alias clock="tty-clock -s -c -C 4"


# adding shourtcuts for bash
alias mkdir='mkdir -p'
alias rm='rm -rf'
alias cp='yes | cp -Ri'
alias pc='xsel --input --clipboard' 
alias pp='xsel --output --clipboard'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
# for search in history
bindkey '\er' history-incremental-search-backward

# Change directory aliases
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdv="cd /home/$USER/.config/nvim"
alias notes="cd /home/$USER/notes"
alias dotfiles="cd /home/$USER/dotfiles"
alias scripts="cd /home/$USER/dotfiles/scripts"
alias build="./build"
alias gf='fzf -m \
  --height=100% \
  --bind="enter:become(nvim {}),ctrl-e:become(vim {})"'
alias fcd="fzf_cd"

# Alias's for multiple directory listing commands
alias la='ls -AFlh' # show hidden files
alias ls='ls -ah --color=always' # add colors and file type extensions
alias lsg='ls | grep ' # add colors and file type extensions
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

# Search files in the current folder
alias f="find . | grep "

# to slove problem in  mind ipconfig
alias ipconfig="ifconfig "

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

# adding the arabic translate from right to left
#alias tran_ara="argos-translate --from en --to ar "


# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' \
| cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--extended --layout=reverse --height=100% '
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Bind ctrl+f to the tmux_new_session function
bindkey -s '^F' 'tm\n'

# for adding some info about the pc
# pfetch 

# for the font for the tty  (for archlinux)
# if [ -z "$DISPLAY" ]; then
# 	setfont /usr/share/kbd/consolefonts/ter-232b.psf.gz
# fi




##****** some functions ********##
fzf_cd() {
    # Use fzf to select a directory from the output of find
    local folder
    folder=$(find "$(pwd)" -type d -print 2>/dev/null | fzf --height 40%)

    # Check if a folder was selected
    if [[ -n "$folder" ]]; then
        cd "$folder" || return
    else
        echo "No folder selected." >&2
        return 1
    fi
}


#go lang setup
# adding path go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go/bin"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"
export PATH="$PATH:$HOME/go/bin/"
export PATH=$PATH:/usr/local/go/bin

# nvm
source /usr/share/nvm/init-nvm.sh
export PATH="$HOME/tools/phpactor/vendor/bin:$PATH"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

# for install using cargo(asm-lsp)
export PATH="$HOME/.cargo/bin:$PATH"
