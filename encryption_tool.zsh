#!/bin/zsh

# Display main menu
main_menu() {
    echo "Please make a selection to get started: "
    echo "1) Encrypt files via symmetric encryption"
    echo "2) Decrypt files via symmetric encryption"
    echo "3) Encrypt files via public/private key"
    echo "4) Decrypt files via public/private key"
    echo "5) Check certificate"
    echo "6) Generate hash"
    echo "7) GPG menu"
    echo -e "99 Quit application \n"

    read choice
    echo " " #Just spacing for readability

    case $choice in
        1) # Encrypt via symmetric encryption
            echo -e "test 1 \n"
            echo "Enter full path of file or directory: "; read -r inputFile
            echo "Enter in the output file or directory name (for post encryption): "; read -r outputFile
            select_algorithm

            openssl enc -"$algorithm" -pbkdf2 -iter 1000000 -md sha256 -salt -in "$inputFile" -out "$outputFile"

            echo "File encrypted successfully using $algorithm!"
        ;;

        2) # Decrypt via symmetric encryption
            echo -e "testing 2 \n"
        ;;

        3) # Encrypt via public/private key
            echo -e "testing 3 \n"

        99) # Exit loop with exit code 0
            echo -e "Exiting! \n"
            exit 0

    esac
}

# Function for selecting algorithm
select_algorithm(){
    echo "Select encryption algorithm to use (showing only the top 10 recommended as of 2024): "
    echo "1) AES-256-GCM"
    echo "2) AES-128-GCM"
    echo "3) ChaCha20-Poly1305"
    echo "4) AES-256-CTR"
    echo "5) AES-128-CTR"
    echo "6) Camellia-256-CBC"
    echo "7) AES-256-XTS"
    echo "8) ARIA-256-GCM"
    echo "9) AES-128-CBC"
    echo "10) Camellia-128-GCM"

    read -r algorithmChoice

    case $algorithmChoice in
        1) algorithm="aes-256-gcm" ;;
        2) algorithm="aes-128-gcm" ;;
        3) algorithm="chacha20-poly1305" ;;
        4) algorithm="aes-256-ctr" ;;
        5) algorithm="aes-128-ctr" ;;
        6) algorithm="camellia-256-cbc" ;;
        7) algorithm="aes-256-xts" ;;
        8) algorithm="aria-256-gcm" ;;
        9) algorithm="aes-128-cbc" ;;
        10) algorithm="camellia-128-gcm" ;;
        *) echo "Invalid selection!"; exit 1 ;;
    esac
    # echo "$algorithm"
}


# Run script in a loop until exited deliberately
while true;
do
    main_menu
done
