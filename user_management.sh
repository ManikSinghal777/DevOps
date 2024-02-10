#!/bin/bash

# Function to display usage information and available options
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --create     Create a new user account."
    echo "  -d, --delete     Delete an existing user account."
    echo "  -r, --reset      Reset password for an existing user account."
    echo "  -l, --list       List all user accounts on the system."
    echo "  -h, --help       Display this help and exit."
}

# Function to create a new user account
function create_user {
 read -p "Please enter username: " username
#check if the username exist
if id "$username" &>/dev/null; then
echo "Error: sorry bud the username $username  already exists"
# Prompt for password (Note: You might want to use 'read -s' to hide the password input)
else
read -p "Please Enter user password for $username: " password

# Create the user account
useradd -m -p "$username" "$password"
echo "user account '$username' created successfully"
fi
}

# Function to delete an existing user account
function delete_user {
 # Check if the username exists
read -p "Enter the username to delete: " username

if id "$username" &>/dev/null; then
sudo userdel -r "$username"
echo "user $username deleted successfully"
else
echo "Error: The user '$username' does not exist. Please enter a valid user:)"
fi
}

# Function to reset the password for an existing user account
function reset_password {
 # Check if the username exists
read -p "Enter the username to reset password: " username

  # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
if id "$username" &>/dev/null; then
read -p "Enter the new password for $username: " password

       # Set the new password
echo "$username:$password" | chpasswd
echo "Password for '$username' reseted successfully"
else
echo "Error: The username $username does not exit. Please enter the valid user."
fi
}

# Function to list all user accounts on the system
function list_users {
echo "user accounts on the system"
cat /etc/passwd | awk -F: '{print "- " $1 " (UID: "$3 ")" }'
}

# Command-line argument parsing
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
display_usage
exit 0
fi

#Command_Line Argument Parsing
while [ $# -gt 0 ]; do
        case "$1" in
           -c|--create)
            create_user
            ;;
           -d|--delete)
            delete_user
            ;;
           -r|--reset)
            reset_password
            ;;
            -l|--list)
            list_users
            ;;
            *)
            echo "Error: Invalid Option '$1'. Use '--help' to see available options."
            exit 1
            ;;
        esac 
       shift
done     
