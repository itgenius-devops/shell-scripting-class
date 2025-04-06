#!/bin/bash

# Author: info@itgenius.io

# Description: A Shell script to install generate a random password for users

# Function to generate a random password
generate_password() {
    local length="$1"
    local use_uppercase="$2"
    local use_lowercase="$3"
    local use_numbers="$4"
    local use_special_chars="$5"

    local charset=''

    # Define character sets based on user preferences
    [[ "$use_uppercase" == "y" ]] && charset+='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    [[ "$use_lowercase" == "y" ]] && charset+='abcdefghijklmnopqrstuvwxyz'
    [[ "$use_numbers" == "y" ]] && charset+='0123456789'
    [[ "$use_special_chars" == "y" ]] && charset+='!@#$%^&*()-=_+[]{}|;:,.<>?/'

    # Check if at least one character set is selected
    if [ -z "$charset" ]; then
        echo "Error: Please select at least one character set."
        exit 1
    fi

    # Generate random password
    local password=$(tr -dc "$charset" < /dev/urandom | head -c "$length")
    echo "$password"
}

# Function to get user preferences
get_user_preferences() {
    read -p "Enter the length of your preferred password (default: 12): " length
    read -p "Do You Want To Include uppercase letters? (y/n): " uppercase_choice
    read -p "Do You Want To Include lowercase letters? (y/n): " lowercase_choice
    read -p "Do You Want To Include numbers? (y/n): " numbers_choice
    read -p "Do You Want To Include special characters? (y/n): " special_chars_choice

    # Setting default values if user presses Enter without providing input
    length=${length:-12}
    uppercase_choice=${uppercase_choice:-"n"}
    lowercase_choice=${lowercase_choice:-"n"}
    numbers_choice=${numbers_choice:-"n"}
    special_chars_choice=${special_chars_choice:-"n"}
}

# Function to display usage information
display_usage() {
    echo "Usage: $0"
}

echo "---Welcome To the Password Generator Script---"

sleep 3

echo "---Here, I Will Help You Generate A Random Strong Password For Your Usage---"

sleep 3

echo "---Please Fill In All Necessary Info To Help Generate The Right Password For You---"

sleep 3
 
# Get user preferences
get_user_preferences

sleep 3

echo "---Thank You For Providing Your Preferences---"

sleep 3

echo "Relax while I Generate Your Password For You"

sleep 3

# Generate and display the password
password=$(generate_password "$length" "$uppercase_choice" "$lowercase_choice" "$numbers_choice" "$special_chars_choice")

echo "Your Generated Password is: $password"

sleep 3

echo "Thank You"

