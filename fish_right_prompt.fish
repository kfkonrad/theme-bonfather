# fish theme: godfather

function prompt_virtualenv
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if set -q CONDA_DEFAULT_ENV
    set env $CONDA_DEFAULT_ENV
  else
    if set -q VIRTUAL_ENV
      set env $VIRTUAL_ENV
    end
  end

  if set -q env
    if test $__bonfather_show_virtualenv=true
      echo -n -s " ($cyan$env$normal)"
    end
  end
end

function fish_right_prompt
  set -l last_status $status
  set -l red (set_color -o red)
  set -l normal (set_color normal)

  # print last exit code if nonzero:
  if test $last_status -ne 0
    set_color red
    printf 'error: %d' $last_status
    set_color normal
  end

  prompt_virtualenv

end
