#color{{{
autoload colors 
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
#}}}


setopt prompt_subst
PROMPT=$(
echo -e "\a
$GREEN%n.%M  $YELLOW  %~  $YELLOW $CYAN\$(vcprompt.py)
$_RED%(?..%?).$WHITE%h$_CYAN>>>$FINISH ")

#标题栏、任务栏样式{{{
#case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
   #precmd () { print -Pn "\e]0;%n@%M//%/\a" }
   #preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
   ##;;
#esac
#}}}

# Zsh settings for history

#关于历史纪录的配置 {{{
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
setopt SHARE_HISTORY
#在命令前添加空格，不将此命令添加到纪录文件中
setopt HIST_IGNORE_SPACE      
#}}}

#每个目录使用独立的历史纪录{{{
#cd() {
    #builtin cd "$@"                             # do actual cd
    #fc -W                                       # write current history  file
    #local HISTDIR="$HOME/.zsh_history$PWD"      # use nested folders for history
        #if  [ ! -d "$HISTDIR" ] ; then          # create folder if needed
            #mkdir -p "$HISTDIR"
        #fi
        #export HISTFILE="$HISTDIR/zhistory"     # set new history file
    #touch $HISTFILE
    #local ohistsize=$HISTSIZE
        #HISTSIZE=0                              # Discard previous dir's history
        #HISTSIZE=$ohistsize                     # Prepare for new dir's history
    #fc -R                                       #read from current histfile
#}
#mkdir -p $HOME/.zsh_history$PWD
#export HISTFILE="$HOME/.zsh_history$PWD/zhistory"

#function allhistory { cat $(find $HOME/.zsh_history -name zhistory) }
#function convhistory {
            #sort $1 | uniq |
            #sed 's/^:\([ 0-9]*\):[0-9]*;\(.*\)/\1::::::\2/' |
            #awk -F"::::::" '{ $1=strftime("%Y-%m-%d %T",$1) "|"; print }'  
#}
##使用 histall 命令查看全部历史纪录
#function histall { convhistory =(allhistory) |
            #sed '/^.\{20\} *cd/i\\' }
##使用 hist 查看当前目录历史纪录
#function hist { convhistory $HISTFILE }

##全部历史纪录 top44
#function top44 { allhistory | awk -F':[ 0-9]*:[0-9]*;' '{ $1="" ; print }' | sed 's/ /\n/g' | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 44 }

#}}}

#Misc{{{
#Enable in-line comment, for example:
#cmd # This is a comment
setopt INTERACTIVE_COMMENTS      
      
# Extendable path
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word
      
# Disable core dumps
limit coredumpsize 0

# Emacs's keybind
bindkey -e
#设置 [DEL]键 为向后删除
bindkey "\e[3~" delete-char

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

#自动补全功能 {{{
setopt AUTO_LIST
setopt AUTO_MENU
#开启此选项，补全时会直接选中菜单项
#setopt MENU_COMPLETE

autoload -U compinit
compinit

#自动补全缓存
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#自动补全选项
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#彩色补全菜单 
eval $(dircolors -b) 
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正      
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#kill 命令补全      
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

#补全类型提示分组 
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}

##行编辑高亮模式 {{{
# Ctrl+@ 设置标记，标记和光标点之间为 region
zle_highlight=(region:bg=magenta #选中区域 
               special:bold      #特殊字符
               isearch:underline)#搜索时使用的关键字
#}}}

##空行(光标在行首)补全 "cd " {{{
user-complete(){
    case $BUFFER in
        "" )                       # 空行填入 "cd "
            BUFFER="cd "
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd --" )                  # "cd --" 替换为 "cd +"
            BUFFER="cd +"
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd +-" )                  # "cd +-" 替换为 "cd -"
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
#}}}

##在命令前插入 sudo {{{
#定义功能 
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#}}}
  
# Aliases {{{
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias la='ls -A'                              #
alias l='ls -CF'                              #
alias cgrep='grep --color=auto -n -I -r'

# SSH alias
alias sshduron="ssh alexmajy@192.168.1.10"
alias sshiphone="ssh root@192.168.1.15"
alias sshipad="ssh root@192.168.1.16"
#alias sensorshaanxi="rdesktop -u administrator -p npu710072 124.115.26.159"
alias sensorshaanxi="rdesktop -u administrator -p 81175050 124.115.26.159"
alias shaanxiiot="rdesktop -u agrienv_user -p npulab505 124.115.26.159"

# miscs alias
alias emacsnx="emacs22-nox"
alias del='mv -t ~/.local/share/Trash/files '
alias makectag="ectags -R"
alias makecscope="cscope -Rbq"
alias lk="gnome-screensaver-command -l"
alias lg="gnome-session-save --logout"
#alias synergy="synergyc 129.132.130.218"
alias vimr="gvim --remote"
alias emax="emacs22-nox"
alias avrora='java -jar ~/develop/avrora/avrora-beta-1.7.106.jar'


# Default to human readable figures
alias df='df -h'
alias du='du -h'

alias cdcx="cd ~/eth/contiki-2.x"

#[Esc][h] man 当前命令时，显示简短说明 
alias run-help >&/dev/null && unalias run-help
autoload run-help

#历史命令 top10
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

##Directories alias {{{
#cd with 'cd ~xxx'
hash -d ETH="$HOME/eth"
hash -d WWW="/var/www"
hash -d PKG="/var/cache/pacman/pkg"
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I="/etc/rc.d"
hash -d X="/etc/X11"
#}}}
    
##for Emacs {{{
#在 Emacs终端 中使用 Zsh 的一些设置 不推荐在 Emacs 中使用它
if [[ "$TERM" == "dumb" ]]; then
setopt No_zle
PROMPT='%n@%M %/
>>'
alias ls='ls -F'
fi 	
#}}}

#{{{ F1 计算器
arith-eval-echo() {
  LBUFFER="${LBUFFER}echo \$(( "
  RBUFFER=" ))$RBUFFER"
}
zle -N arith-eval-echo
bindkey "^[[11~" arith-eval-echo
#}}}

####{{{
function timeconv { date -d @$1 +"%Y-%m-%d %T" }

# }}}

####{{{ Environment variables
# export set LC_ALL=zh_CN.GBK
# export LANG="en_US.UTF-8"
# export LC_CTYPE="zh_CN" 

 export PATH="$HOME/scripts:$PATH:/opt/apache-ant-1.7.1/bin:/usr/local/avr/bin"
# export LD_LIBRARY_PATH=""
 export ANT_HOME="/opt/apache-ant-1.7.1"
 export JAVA_HOME="/usr/lib/jvm/java-6-openjdk"
 #export CVSROOT="$HOME/cvsroot"
 export EDITOR=vim
 export PYTHONSTARTUP=''
 export JAVA_HOME="/usr/lib/jvm/java-6-sun"
 export CLASSPATH="$CLASSPATH:/usr/share/antlr/antlr-3.1.jar:."

 export XMODIFIERS="@im=fcitx"
 export XIM=fcitx
 export XIM_PROGRAM=fcitx

# special setting for awesome windows manager
  export AWT_TOOLKIT=MToolkit
  #export LIS_PATH="$HOME/lis-core"
  

# }}}

####{{{ Routines 
function iipa {
    scp $1 root@192.168.1.16:/User/Documents/Installous/Downloads
}

function mypyhttp {
    python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"
}

function vimr {
    gvim --remote $@
}
function vimnr {
    gvim --remote --servername $@
}


mvpn() {
    case $1 in
        'stop') 
           PID=`ps aux | awk '{if ($1=="root" && $11=="openvpn") print $2}'`
           echo "Kill openvpn with pid:$PID"
           sudo kill -9 $PID;;
        'start') 
           echo "Start openvpn in background with '/home/alexmajy/vpn/Automatic.ovpn'"
           cd /home/alexmajy/vpn
           sudo openvpn --config Automatic.ovpn;;
        *) echo "usage:"
           echo "mvpn          # check the status"
           echo "mvpn stop     # stop vpn service"
           echo "mvpn start    # start vpn service"
           echo ""
           ps aux | awk '{if ($1=="root" && $11=="openvpn") print $0}';;
    esac
}


function dsmode-home {
    xrandr --output VGA1 --auto --output LVDS1 --off
}

function dsmode-vu {
    xrandr --output VGA1 --auto --output LVDS1 --auto --below VGA1
}

function dsmode-reset {
    xrandr --output LVDS1 --auto --output VGA1 --off
}

function dsmode-mirrow {
   xrandr --output LVDS1 --auto --output VGA1 --auto --same-as LVDS1
}

function tos2 {
	source /opt/tinyos-2.1.0/tinyos.sh
}

function tos2.x {
	source /opt/tinyos-2.x/tinyos.sh
}

function tos2xx {
	source /opt/tinyos-2.x.svn/tinyos.sh
}

function tos1.x {
	source /opt/tinyos-1.x/tinyos.sh
}

function android-setup {
        export PATH="$PATH:/home/alexmajy/dev/android-sdk-linux_86/tools"
}

function mbc {
    echo "scale=4; $@" | bc
}

function mps {
    ps aux | grep $@
}

setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -ne "\ek$CMD\e\\"
    fi
}



# }}}

source /etc/zsh_command_not_found

# to make java look normal
#wmname LG3D

if [ $TERM != screen -a $TERM != screen-bce -a $TERM != rxvt-unicode ]; then
    echo 
    fortune
fi

## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4 
