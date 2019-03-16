# fish theme: godfather

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
end
