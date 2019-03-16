# fish theme: bonfather

function set_unless_exists
  if [ -z "$$argv[1]" ]
    set -g $argv[1] $argv[2]
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

# change color depending on the user.
function _user_host
  if [ "(id -u)" = "0" ];
    echo -n (set_color -o red)
  else
    echo -n (set_color -o blue)
  end
  echo -n (hostname|cut -d . -f 1)ˇ$USER (set color normal)
end

function parse_git_dirty
  set -l submodule_syntax
  set submodule_syntax "--ignore-submodules=dirty"
  set git_dirty (command git status --porcelain $submodule_syntax  2> /dev/null)
  command git status --porcelain $submodule_syntax  2> /dev/null | command grep -e "^?? " -e "^ M " 2>/dev/null >/dev/null
  set git_added $status
  if [ -n "$git_dirty" ]
    if [ "$__fish_git_prompt_showdirtystate" = "yes" ]
      if [ "$git_added" = 1 ]
        echo -n "$__fish_git_prompt_char_addedstate"
      else
        echo -n "$__fish_git_prompt_char_dirtystate"
      end
    end
  else
    if [ "$__fish_git_prompt_showdirtystate" = "yes" ]
      echo -n "$__fish_git_prompt_char_cleanstate"
    end
  end
end

function prompt_git -d "Display the current git state"
  set -l ref
  set -l dirty
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set dirty (parse_git_dirty)
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    if [ "$status" -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
      set ref " > $branch"
    end
    set -l branch (echo $ref | sed  "s-refs/heads/-$branch_symbol -")
    if [ "$KFK_NOBRANCH" = "" ]
      if [ "$dirty" != "" ]
        echo -n "$yellow$branch $dirty"
        set -g KFK_VERSIONING '_'
      else
        echo -n "$green$branch"
        set -g KFK_VERSIONING '_'
      end
    else
      if [ "$dirty" != "" ]
        echo -n $yellow hello
      else
        echo -n $green elho
      end
    end
  end
  echo -n $normal
end

function fish_prompt_flexible
  set fish_greeting
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set -l cwd $cyan$argv[1]

  set_unless_exists __fish_git_prompt_showdirtystate 'yes'
  set_unless_exists __fish_git_prompt_char_dirtystate '±'
  set_unless_exists __fish_git_prompt_char_cleanstate ''
  set_unless_exists __fish_git_prompt_char_addedstate '•'

  # output the prompt, left to right:
  # display 'user@host:'
  if [ "$USER" = "root" ]
    set user_color $red
    set_unless_exists __fish_prompt_nicepromptchar '#'
  else
    set user_color $green
    set_unless_exists __fish_prompt_nicepromptchar '$'
  end
  echo -n -s $user_color $USER @ (hostname|cut -d . -f 1) ": "

  # display the current directory name:
  echo -n -s $cwd $normal

  prompt_git

  # terminate with a nice prompt char:
  echo -n -s " $__fish_prompt_nicepromptchar " $normal
end

function fish_prompt
  set -l long_prompt_output (fish_prompt_flexible (prompt_pwd))
  if [ (string length (string trim (echo -n $long_prompt_output | perl -pe 's/\x1b\[[0-9;]*[mG]//g' ))) -ge $COLUMNS ]
    set -l fish_prompt_pwd_dir_length_save $fish_prompt_pwd_dir_length
    set -g fish_prompt_pwd_dir_length 1
    set -l short_prompt_output (fish_prompt_flexible (prompt_pwd))
    set -g fish_prompt_pwd_dir_length $fish_prompt_pwd_dir_length_save
    if [ (string length (string trim (echo -n $short_prompt_output | perl -pe 's/\x1b\[[0-9;]*[mG]//g' ))) -ge $COLUMNS ]
      fish_prompt_flexible (basename (prompt_pwd))
    else
      echo -n $short_prompt_output
    end
  else
    echo -n $long_prompt_output
  end
end
