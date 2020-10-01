# -*- mode: sh; -*-

# Dracula Theme v1.2.5
#
# https://github.com/dracula/dracula-theme
#
# Copyright 2019, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author Zeno Rocha <hi@zenorocha.com>
# @maintainer Aidan Williams <aidanwillie0317@protonmail.com>

# Initialization {{{
source ${0:A:h}/lib/async.zsh
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST
async_init
# }}}

# Set to 1 to show the 'context' segment
DRACULA_DISPLAY_CONTEXT=${DRACULA_DISPLAY_CONTEXT:-1}

# use --no-optional-locks flag on git
DRACULA_GIT_NOLOCK=${DRACULA_GIT_NOLOCK:-1}
# }}}

# Status + user context segment {{{
STATUS='%(?:%F{green}:%F{red})|'
PROMPT='%B$STATUS%F{magenta}%n@%m$STATUS'
# }}}

# Directory segment {{{
PROMPT+='%F{blue}%B%~ '
# }}}

# Async git segment {{{

dracula_git_status() {
  cd "$1"
  
  local ref branch lockflag
  
  (( DRACULA_GIT_NOLOCK )) && lockflag="--no-optional-locks"

  ref=$(=git $lockflag symbolic-ref --quiet HEAD 2>/tmp/git-errors)

  case $? in
    0)   ;;
    128) return ;;
    *)   ref=$(=git $lockflag rev-parse --short HEAD 2>/tmp/git-errors) || return ;;
  esac

  branch=${ref#refs/heads/}
  
  if [[ -n $branch ]]; then
    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}"

    local git_status icon
    git_status="$(LC_ALL=C =git $lockflag status 2>&1)"
    
    if [[ "$git_status" =~ 'new file:|deleted:|modified:|renamed:|Untracked files:' ]]; then
      echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

    echo -n "$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

dracula_git_callback() {
  DRACULA_GIT_STATUS="$3"
  zle && zle reset-prompt
  async_stop_worker dracula_git_worker dracula_git_status "$(pwd)"
}

dracula_git_async() {
  async_start_worker dracula_git_worker -n
  async_register_callback dracula_git_worker dracula_git_callback
  async_job dracula_git_worker dracula_git_status "$(pwd)"
}

precmd() {
  dracula_git_async
}

PROMPT+='$DRACULA_GIT_STATUS'

ZSH_THEME_GIT_PROMPT_CLEAN=") %F{green}%B✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %F{yellow}%B✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}%B("
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%b"
# }}}

# Ensure effects are reset
PROMPT+='%f%b'

