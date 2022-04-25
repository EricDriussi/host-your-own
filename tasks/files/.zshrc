export EDITOR="nvim"
export VISUAL="nvim"
export ZSH="~/.custom-zsh"
export MANPAGER='nvim +Man!'

export PATH=$HOME/bin:/usr/bin:$PATH
export PATH=$PATH:/opt

# vifm
export PATH=$PATH:$HOME/.config/vifm
export PATH=$PATH:$HOME/.config/vifm/vifmimg

# fzf defaults
export FZF_DEFAULT_COMMAND='rg --files -g "!node_modules/" -g "!.git/" --hidden .'
export FZF_DEFAULT_OPTS='--height 70% --layout=reverse --border --preview="head -$LINES {}" --info=inline'

# zsh_history settings
HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Vi mode
#bindkey -v
export KEYTIMEOUT=1
