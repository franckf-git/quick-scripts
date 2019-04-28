#!/bin/bash

echo 
echo "== Script avec confirmation =="
echo 

confirm()
{
    read -r -p "${1} [y/N] " response

    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

if confirm "Do you like apples?"; then
    echo "Good!"
else
    echo "You miss something!"
fi

exit



#Read command without enter

#read -p " Are you Sure?" -n 1 ans
#echo $ans