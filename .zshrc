#----------------------- prompt ---------------------------------#
autoload colors
colors
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval $color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"

# setting for vcprompt
VCPROMPT="$HOME/.dotfiles.d/scripts/vcprompt -f '[%s:%b]'"

setopt prompt_subst
PROMPT=$(
echo -e "\a
$GREEN%n.%M  $YELLOW  %~  $YELLOW $CYAN\$($VCPROMPT)
$_RED%(?..%?).$WHITE%h$_CYAN>>>$FINISH ")


#----------------------- history --------------------------------#
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
# enable 'cd -[TAB]' shortcut
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt SHARE_HISTORY
# ignore cmd with blank prefix
setopt HIST_IGNORE_SPACE      


#----------------------- misc settings --------------------------#
# enable in-line comment, e.g.: $ cmd # This is a comment
setopt INTERACTIVE_COMMENTS      
# extendable path, e.g. /v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word
# disable core dumps
limit coredumpsize 0
# emacs's keybind and [DEL] bind
bindkey -e
bindkey "\e[3~" delete-char
# define a word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'


#----------------------- auto completion ------------------------#
setopt AUTO_LIST
setopt AUTO_MENU
autoload -U compinit
compinit

zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

# completion with colors
eval $(dircolors -b) 
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# completion for "cd ~"
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

user-complete(){
    case $BUFFER in
        "" )                       # nothing + tab -> cd 
            BUFFER="cd "
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd --" )                  # "cd --" -> "cd +"
            BUFFER="cd +"
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd +-" )                  # "cd +-" -> "cd -"
            BUFFER="cd -"
            zle end-of-line
            zle expand-or-complete
            ;;
        * )
            zle expand-or-complete
            ;;
    esac
}
zle -N user-complete
bindkey "\t" user-complete


#----------------------- add sudo before cmd --------------------#
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line                 # move cursor to the end
}
zle -N sudo-command-line
# bind shortcut: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
  

#----------------------- alias ----------------------------------#
source .dotfiles.d/shell_aliases
#[Esc][h] man 
alias run-help >&/dev/null && unalias run-help
autoload run-help
# directories aliases, cd with 'cd ~xxx'
hash -d WWW="/var/www"
hash -d PKG="/var/cache/pacman/pkg"
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I="/etc/rc.d"
hash -d X="/etc/X11"


#----------------------- manpage color --------------------------#
source .dotfiles.d/manpages_colors
#----------------------- environment variables ------------------#
source .dotfiles.d/env_vars
source /etc/zsh_command_not_found

#----------------------- functions ------------------------------#
source .dotfiles.d/shell_funs
#----------------------- no idea --------------------------------#
setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -ne "\ek$CMD\e\\"
    fi
}

