function fish_prompt
  # Store the status because all the commands to generate this prompt will overwrite it
  set last_status $status

  set_color $fish_color_cwd
  echo -n (pwd | sed -E 's@(.*/)?([^/]*/[^/]*)@\2@')
  set_color normal

  # Print a dot for failed commands (some symbols ●○⦿◉)
  if test $last_status -gt 0
    set_color red    ; echo -n '❯'
    set_color normal
  else
    set_color green  ; echo -n "❯"
  end

end
