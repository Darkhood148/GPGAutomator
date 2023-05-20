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
        echo "Enter the gpg key code you want to use"
        declare -A map
        str=$(gpg --list-secret-keys --keyid-format=long | grep "sec")
        i=0
        j=0
        for word in $str;
        do
            i=$(($i+1))
            mod=$(($i % 4))
            if [[ $mod -eq 2 ]]; then
                j=$(($j+1))
                result="${word#*/}"
                map[$(echo $j)]=$result
                echo "$j - $result"
            fi
        done
        read ch
        key=${map[$(echo $ch)]}
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
            i=0
            for word in $str; 
            do
                i=$(($i+1))
                mod=$(($i % 4))
                if [[ $mod -eq 2 ]]; then
                    result="${word#*/}"
                    echo $result
                fi
            done
        fi
    else
        break
    fi
done