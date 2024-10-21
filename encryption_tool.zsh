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
            echo "Enter full path of file or directory: "; read -r inputFile
            echo "Enter in the output file or directory name (for post encryption): "; read -r outputFile
            select_algorithm

            # if [[ $algorithm == *"gcm"* || $algorithm == *"chacha20-poly1305"* ]]; then
            #     key=$(openssl rand -hex 32)
            #     iv=$(openssl rand -hex 12)

            #     openssl enc -"$algorithm" -K "$key" -iv "$iv" -in "$inputFile" -out "$outputFile"

            # else
            openssl enc -"$algorithm" -pbkdf2 -iter 1000000 -md sha256 -salt -in "$inputFile" -out "$outputFile"
            # fi

            echo "File encrypted successfully using $algorithm!"
        ;;

        2) # Decrypt via symmetric encryption
            echo "Enter full path of encrypted file or directory: "; read -r inputFile
            echo "Enter in the output file or directory name (for post decryption): "; read -r outputFile
            select_algorithm
            openssl enc -"$algorithm" -d -pbkdf2 -iter 1000000 -md sha256 -salt -in "$inputFile" -out "$outputFile"

        ;;

        3) # Encrypt via public/private key
            echo -e "testing 3 \n"
        ;;

        99) # Exit loop with exit code 0
            echo -e "Exiting! \n"
            exit 0

    esac
}

# Function for selecting algorithm
select_algorithm(){
    echo "Select encryption/decryption algorithm to use: "
    echo "1) AES-128-CBC"
    echo "2) AES-192-CBC"
    echo "3) AES-256-CBC"
    echo "4) AES-128-ECB"
    echo "5) AES-192-ECB"
    echo "6) AES-256-ECB"
    echo "7) Camellia-256-CBC"
    echo "8) AES-256-XTS*"
    echo "9) ARIA-256-GCM*"
    echo "10) AES-256-CTR"
    echo "11) AES-128-CTR"

    read -r algorithmChoice

    case $algorithmChoice in
        1) algorithm="aes-128-cbc" ;;
        2) algorithm="aes-192-cbc" ;;
        3) algorithm="aes-256-cbc" ;;
        4) algorithm="aes-128-ecb" ;;
        5) algorithm="aes-192-ecb" ;;
        5) algorithm="aes-256-ecb" ;;
        7) algorithm="camellia-256-cbc" ;;
        8) algorithm="aes-256-xts" ;;
        9) algorithm="aria-256-gcm" ;;
        10) algorithm="aes-256-ctr" ;;
        11) algorithm="aes-128-ctr" ;;
        *) echo "Invalid selection!"; exit 1 ;;
    esac
    echo ""
    # echo "$algorithm"
}


# Run script in a loop until exited deliberately
while true;
do
    main_menu
done
