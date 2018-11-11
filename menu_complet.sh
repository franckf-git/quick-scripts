#!/bin/bash

function Menu1_function()
{    clear 2>/dev/null
    echo "          "
    printf "\nExplain menu\n\n"
                
    commande
    commande
    ...
    
    main
}

function main()
{    clear 2>/dev/null
    echo "          "
    printf "\nExplain options\n\n"
    
    PS3='Please enter your choice: '
    options=("Menu1" "Menu2" "Menu3" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Menu1")
                Menu1_function
                ;;
            "Menu2")
                Menu2_function
                ;;
            "Menu3")
                Menu3_function
                ;;
             "Quit") 
                break
                exit 1
                ;;
            *) echo invalid option;;
        esac
    done
}

main