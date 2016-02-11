function fish_right_prompt -d "Write out the right prompt"
  set -g __fish_git_prompt_show_informative_status 1
  set -g __fish_git_prompt_showcolorhints          1

  set -g __fish_git_prompt_color             black
  set -g __fish_git_prompt_color_prefix      black
  set -g __fish_git_prompt_color_suffix      black
  set -g __fish_git_prompt_color_bare     blue
  set -g __fish_git_prompt_color_merging  red
  set -g __fish_git_prompt_color_branch   black
  set -g __fish_git_prompt_color_flags    yellow
  set -g __fish_git_prompt_color_upstream magenta

  set -g __fish_git_prompt_char_upstream_prefix ' '
  set -g __fish_git_prompt_char_upstream_ahead  '↑'
  set -g __fish_git_prompt_char_upstream_behind '↓'
  set -g __fish_git_prompt_char_stateseparator  ''
  set -g __fish_git_prompt_char_dirtystate      '✚'
  set -g __fish_git_prompt_char_invalidstate    '✖'
  set -g __fish_git_prompt_char_stagedstate     '●'
  set -g __fish_git_prompt_char_untrackedfiles  '≠'
  set -g __fish_git_prompt_char_cleanstate      '✔'

  __fish_git_prompt
end
