#!/bin/zsh

# Display main menu
main_menu() {
    echo "" 
    echo "Please make a selection to get started: "
    echo "1) Encrypt files via symmetric encryption"
    echo "2) Decrypt files via symmetric decryption"
    echo "3) Encrypt files via asymmetric encryption"
    echo "4) Decrypt files via asymmetric decryption"
    echo "5) Generate Hash"
    echo "6) Check Certificate"
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

            echo "File successfully decrypted"; 
            ls -l $outputFile

        ;;

        3) # Encrypt via public/private key
            echo "Enter in full path of recipient's public key: "; read -r publicKey
            echo "Enter in full path of file to encrypt: "; read -r inputFile
            echo "What do you want the name of the output file to be? Please use full path again: "; read -r outputFile
            openssl pkeyutl -encrypt -inkey "$publicKey" -pubin -in "$inputFile" -out "$outputFile"

            echo "File successfully encrypted"; 
            ls -l $outputFile

        ;;

        4) # Decrypt via public/private key
            echo "Enter in full path of your private key: "; read -r privateKey
            echo "Enter in full path of file to decrypt: "; read -r inputFile
            echo "What do you want the name of the output file to be? Please use full path again: "; read -r outputFile
            openssl pkeyutl -decrypt -inkey "$privateKey" -in "$inputFile" -out "$outputFile"

            echo "File successfully decrypted"; 
            ls -l $outputFile

        ;;

        5) # Generate and check hashes
            echo "Enter full path of file or directory: "; read -r inputFile
            select_hash
            openssl dgst -"$hashAlgorithm" "$inputFile"
        ;;

        6) # Check the certificate provided
            echo "Enter full path of certificate: "; read -r inputFile
            echo "Are you checking an rsa key or x509 certificate? Type in 'rsa' or 'x509': "; read -r certType
            echo

            if [[ $certType == "x509" ]]; then
                openssl x509 -in "$inputFile" -text -noout

            elif [[ $certType == "rsa" ]]; then
                openssl rsa -in "$inputFile" -text -noout
            
            else
                echo "Did not receive rsa or x509 choice! Please try again."
            fi
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
        *) echo "Invalid selection! Please try again. "; select_algorithm ;;
    esac
    echo " " #spacing for readability
    # echo "$algorithm"
}

select_hash(){
    echo "Select hash function to use: "
    echo "1) blake2b512"
    echo "2) blake2s256"
    echo "3) md5"
    echo "4) rmd160"
    echo "5) sha1"
    echo "6) sha224"
    echo "7) sha256"
    echo "8) sha3-224"
    echo "9) sha3-256"
    echo "10) sha3-384"
    echo "11) sha3-512"
    echo "12) sha384"
    echo "13) sha512"
    echo "14) sha512-224"
    echo "15) sha512-256"
    echo "16) shake128"
    echo "17) shake256"
    echo "18) sm3"

    read -r hashAlgorithmChoice

    case $hashAlgorithmChoice in
        1) hashAlgorithm="blake2b512" ;;
        2) hashAlgorithm="blake2s256" ;;
        3) hashAlgorithm="md5" ;;
        4) hashAlgorithm="rmd160" ;;
        5) hashAlgorithm="sha1" ;;
        5) hashAlgorithm="sha224" ;;
        7) hashAlgorithm="sha256" ;;
        8) hashAlgorithm="sha3-224" ;;
        9) hashAlgorithm="sha3-256" ;;
        10) hashAlgorithm="sha3-384" ;;
        11) hashAlgorithm="sha3-512" ;;
        12) hashAlgorithm="sha384" ;;
        13) hashAlgorithm="sha512" ;;
        14) hashAlgorithm="sha512-224" ;;
        15) hashAlgorithm="sha512-256" ;;
        16) hashAlgorithm="shake128" ;;
        17) hashAlgorithm="shake256" ;;
        18) hashAlgorithm="sm3" ;;
        *) echo "Invalid selection! Please try again. "; select_hash ;;
    esac
    echo " " #spacing for readability
}


# Run script in a loop until exited deliberately
while true;
do
    main_menu
done
