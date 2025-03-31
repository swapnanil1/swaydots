function fish_prompt
    set -l full_path (pwd)
    set -l path_parts (string split / $full_path)
    set -l truncated_parts

    for part in $path_parts
        if test -n "$part"
            # disply first 6 characters; change to your like
            set -a truncated_parts (string sub --length 6 $part)
        else
            # this preserved the empty parts (handeling the leading '/' correctly)
            set -a truncated_parts ""
        end
    end
    set -l display_path (string join / $truncated_parts)
    set_color 50BFB4
    echo -n $display_path # Print the truncated path
    set_color yellow
    echo -n ' > '
    set_color normal
end
