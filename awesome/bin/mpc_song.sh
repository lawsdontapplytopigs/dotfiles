#!/usr/bin/bash
# first, let's get the song name
song_name=$(mpc -f '%file%' | # get the file name from mpc
head -n1 | # get the first line
egrep -o '\/?[^/]*\.[A-Za-z0-9]+' | # actually get the file name, without the leading directory names and their forwars slashes
sed 's/^[\/ ]*//') # remove the leading forward slash if it has one

# now, let's format it
formatted_name=$(echo "$song_name" |
# replace every hyphen with one or more leading and trailing spaces with just hyphens, 
# so we know that in the end we'll just add one space before and after to look good
sed 's/ *- * /-/' | 
sed 's/\.[A-Za-z0-9]\+//' | # cut out the extension (eg '.mp3')
# print out everything, separated by a space, a hyphen and a trailing space
awk 'BEGIN { FS="-" } { for (i=1; i<=NF; i++) printf $i" - "}' | 
sed 's/ - $//' # from the last command, an additional hyphen gets printed at the end. this takes it out
)
echo "$formatted_name"
