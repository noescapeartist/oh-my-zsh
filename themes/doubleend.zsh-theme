function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  echo "${PWD/#$HOME/~}"
}

function battery_charge() {
  echo `python ~/bin/batcharge.py` 2>/dev/null
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 18))
  else
    git=0
  fi

  local bat=$(battery_charge)
  if [ ${#bat} != 0 ]; then
    ((bat = ${#bat} - 18))
  else
    bat=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  echo $spacing
}

PROMPT=$'
%{$fg[cyan]%}%m: %{$fg[yellow]%}$(get_pwd)$(put_spacing)$(git_prompt_info) $(battery_charge)
%{$reset_color%}→ '

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"