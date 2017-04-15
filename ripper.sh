#!/bin/bash

#
#title           : ripper.sh
#description     : This script will generate public and private key,encrypt and decrypt a chosen file.
#author          : Matus Mihok & Andreas Pitziolis
#date            : 10.03.2017
#version         : 0.1
#usage           : bash ripper.sh
#notes           : ---
#bash_version    : 4.4.11(1) -release
# 

##########################################################################################################

#this is just checking if openssl is installed, otherwise it is not possible to use the script

##########################################################################################################

OPENSSL_LOC="$(which openssl)"

if [ "$OPENSSL_LOC" = "" ]; then
   	echo "OpenSSL not found! Please install before running ./ripper.sh "
   	sleep 3		#This pauses the echo statement for a few seconds (3)
	exit
fi
##########################################################################################################
#The following IF statements check if the folders that are going to be needed are there. 
#IF NOT....it creates them
if [ ! -d ~/bin ];
	then
	mkdir ~/bin
fi

if [ ! -d ~/bin/ripper ];
	then
	mkdir ~/bin/ripper
fi

if [ ! -d ~/bin/ripper/keys ];
	then
	mkdir ~/bin/ripper/keys
fi

if [ ! -d ~/bin/ripper/keys/public ];
	then
	mkdir ~/bin/ripper/keys/public
fi

if [ ! -d ~/bin/ripper/keys/private ];
	then
	mkdir ~/bin/ripper/keys/private
fi

if [ ! -d ~/bin/ripper/files ];
	then
	mkdir ~/bin/ripper/files
fi

##########################################################################################################

#main menu interface 

##########################################################################################################

function menu() 
{ 
	clear   				#wipe the shell
	echo "Matus Mihok & Andreas Pitziolis"
	echo "Version 0.1"
	echo "############################"
	echo ">>> "R I P P E R" <<<" | toilet --gay --font future 
	echo "############################"
	date   					#BIC which simply shows actual date and time
	echo "############################"
	echo "Welcome $USER to Ripper, secure file manager"
	echo "1: Generate private and public key"
	echo "2: Encrypt file using public key"	
	echo "3: Decrypt file using private key"
	echo "4: Create File"
	echo "5: View Files"	
	echo "6: Help"
	echo "7: Credits" 
	echo "X: Exit"
	echo "############################"
	echo "Select an option:"
	read user_input
	case $user_input in
		1)	generate 
			;;

		2)
			encrypt
			;;
		3)
			decrypt
			;;
		4)
			createfile
			;;

		5)
			viewfile
			;;
		6)	
			helper
			;;
		7)	
			credits
			;;
		
		[x] | [X])
			
		clear	#wipe the shell
		echo ". . . THANK YOU FOR USING THE SCRIPT . . ."
		echo 
		echo "		Matus & Andreas"
		sleep 2
		exit
		;;

		*)
		menu
		;;
	esac
}

#end of the menu  
##########################################################################################################

##########################################################################################################

#helper function, simply prints the HELP information

##########################################################################################################
function helper() 
{ 	
	clear #wipe the shell
	echo ". . .W E L C O M E	T O	H E L P. . ."
	echo " "
	echo "OPTION 1: Generates 1 PUBLIC and 1 PRIVATE set of keys that are going to be used to encrypt and decrypt a choosen file respectivelly"
	echo 
	echo " "
	echo "OPTION 2: Encrypts a choosen file with a choosen PUBLIC key and creates an UNREADABLE file"
	echo
	echo " "
	echo "OPTION 3: Decrypts a file that has been encrypted with a PUBLIC key to view the contents"
	echo
	echo " "
	echo "OPTION 4: Gives the option to create a file as well as entering text that will be stored in the same file"
	echo
	echo " "
	echo "OPTION 5: Gives the option to view the list of files available"
	echo
	echo " "
	echo "OPTION 6: This is the help menu (You are currently in this option :)"
	echo
	echo " "
	echo "OPTION 7: Displays the credits"
	echo " "
	read -p "Press [Enter] to return to menu"
	menu

}
#end of the helper function
##########################################################################################################

#decrypt function - will ask what file has to be decrypted with what key stored in /bin/keys directory

##########################################################################################################
function decrypt() 
{				
	clear #wipe the shell
	echo "The following files exist in this directory:"
	echo ""
	ls ~/bin/ripper/files
	echo ""
	echo "Enter the name of the file to decrypt :"
	read file_to_decrypt
	echo ""
	echo "The following key files exist in your" $USER"/bin/ripper/keys/ directory:"
	echo ""
	ls ~/bin/ripper/keys/private
	echo ""
	echo "Enter the name of the PRIVATE KEY file to decrypt the file with:"
	read decryption_key_file
	#decrypt using openssl
	openssl rsautl -decrypt -inkey ~/bin/ripper/keys/private/$decryption_key_file -in ~/bin/ripper/files/$file_to_decrypt -out ~/bin/ripper/files/$file_to_decrypt.decrypted
	echo ""
	echo "Decrypted file saved to $file_to_decrypt.decrypted"
	echo ""
	read -p "Press [Enter] to return to menu"
	menu
}
#end of the decrypt function
##########################################################################################################

#encrypt function - will ask what file has to be encrypted with what key stored in /bin/keys directory

##########################################################################################################
function encrypt() 
{
	clear   #wipe the shell
	echo "The following files exist in this directory:"
	echo ""
	ls ~/bin/ripper/files/
	echo ""
	echo "Enter the name of the file to encrypt :"
	read file_to_encrypt
	echo ""
	echo "The following key files exist in your" $USER"/bin/ripper/keys/ directory:"
	echo
	ls ~/bin/ripper/keys/public
	echo ""
	echo "Enter the name of the PUBLIC KEY file to encrypt data with:"
	read encryption_key_file
	echo ""
	#encrypt using openssl			
	openssl rsautl -encrypt -inkey ~/bin/ripper/keys/public/$encryption_key_file -pubin -in ~/bin/ripper/files/$file_to_encrypt -out ~/bin/ripper/files/$file_to_encrypt.encrypted			
	echo ""
	echo "Encrypted file saved to $file_to_encrypt.encrypted"
	echo ""
	read -p "Press [Enter] to return to menu"
	menu
}
#end of the encrypt function
##########################################################################################################

#generate function - generating public and private key, will ask for name for private and public key. Keys are stored in /bin/keys directory

##########################################################################################################
function generate() 
{
	clear
	echo "Your new private and public key will be stored in your" $USER"/bin/ripper/keys/ directory"
	echo " "
	echo "Enter the name of your private key"
	echo " "
	read private_name
	echo " "
	openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -pkeyopt rsa_keygen_pubexp:3 -out ~/bin/ripper/keys/private/$private_name.pem
	echo " "
	echo "Private key saved to saved to ~/bin/ripper/keys/private"
	echo " "
	echo "Enter the name of your public key"
	echo " "
	read public_name
	echo " "
	openssl pkey -in ~/bin/ripper/keys/private/$private_name.pem -out ~/bin/ripper/keys/public/$public_name.pem -pubout
	echo "Public key saved to ~/bin/ripper/keys/public"
	echo " "
	read -p "Press [Enter] to return to menu"
	menu
}
#end of the generate function
##########################################################################################################

#createfile function - Creates a file and stores it in /bin/files directory

##########################################################################################################
function createfile() 
{
	echo -n "Please enter the name of the file you want to create: "
	read name0fFile
	echo "Please enter text that you want to store in the file: "
	read textInFile
	echo $textInFile > ~/bin/ripper/files/$name0fFile
	clear
	echo "File successfully created"
	sleep 2
	timer
	menu		
}
#end of the generate function
##########################################################################################################

#credits function, simply prints the credits information

##########################################################################################################
function credits() 
{ 	
	clear 
	echo "This script was created for academic purposes by Matus Mihok & Andreas Pitziolis"
	sleep 2
	clear
	clear 
	echo "Middlesex University London"
	sleep 2
	clear
	clear 
	echo "MARCH 2017"
	sleep 2
	clear
	clear 
	echo "CCE4350-Penetration Testing and Digital Forensics"
	sleep 2
	timer 
	menu
}
#end of the credits function
##########################################################################################################

#timer function, simply prints the numbers 1-3 in reverse order for visualization purposes

##########################################################################################################
function timer() 
{ 
	clear 
	echo "Returning to the menu"
	echo "3"
	sleep 1	
	clear 
	echo "Returning to the menu"
	echo "2"
	sleep 1
	clear 
	echo "Returning to the menu"
	echo "1"
	sleep 1	
}
#end of the timer function
##########################################################################################################

#viewfile function - Displays the files located in the /bin/files directory

##########################################################################################################
function viewfile() 
{
	ls ~/bin/ripper/files
	echo " "
	read -p "Press [Enter] to return to menu"
	menu
}
#end of viewfile function
##########################################################################################################
	
#initiate menu

##########################################################################################################

menu

#################################################################################################################################################################################
