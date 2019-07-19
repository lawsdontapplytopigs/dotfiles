function fish_prompt
	test $SSH_TTY
    and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
    test "$USER" = 'root'
    and echo (set_color red)"#"

    # Main
    echo -n (set_color ccffee)(prompt_pwd) (set_color 104060)'❯'(set_color 4f8fcc)'❯'(set_color a0dfff)'❯ '
end
