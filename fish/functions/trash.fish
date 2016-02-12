function trash --description "Moves all the files into the trash"
  for file in $argv
    # Normalize the path
    set -l file (cd (dirname $file); pwd)/(basename $file)
    # If the file is found, then delete. Otherwise error
    if [ -e $file ]
      echo -n "Removing file "
      set_color cyan
      echo -n $file
      set_color normal
      /usr/bin/env osascript -e "tell application \"Finder\" to delete POSIX file \"$file\"" 1>/dev/null
    else
      set_color red
      echo -n "Cannot find the file "
      set_color cyan
      echo $file
      set_color normal
      echo ""
    end
  end
end
