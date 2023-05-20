#!/bin/bash

printf "Enter 1 to generate a gpg key\nEnter 2 to use a gpg key for signing\nEnter 3 to list available gpg keys\nEnter any other key to exit\n"
for(( ; ; ))
do
    read choice
    if [[ choice -eq 1 ]]; then
        printf "\n\n\n~~~~Generating Key~~~~\n\n\n"
        gpg --full-generate-key
        printf "\n\n\n~~~~Key Successfully Generated~~~~\n\n\n"
    elif [[ choice -eq 2 ]]; then
        echo "Enter the gpg key you want to use"
        read key
        git config --global user.signingkey "$key"
        printf "Fill this as your gpg key in your GitHub account\n\n\n"
        gpg --armor --export $key
        printf "\n\n\n"
    elif [[ choice -eq 3 ]]; then
        str=$(gpg --list-secret-keys --keyid-format=long | grep "sec")
        len=${#str}
        if [[ len -eq 0 ]]; then
            printf "There are no keys. Use (1) to generate one"
        else
            echo -e $str
        fi
    else
        break
    fi
done