function fish_prompt
	test $SSH_TTY
    and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
    test "$USER" = 'root'
    and echo (set_color red)"#"

    # Main
    echo -n (set_color cceeff)(prompt_pwd) (set_color 432b6b)'❯'(set_color 8860ed)'❯'(set_color c8b0ff)'❯ '
end
