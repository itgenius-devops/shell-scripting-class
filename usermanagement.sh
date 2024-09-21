#!/bin/bash

# Prompt for group name and group ID
read -p "Enter group name: " group_name
read -p "Enter group ID: " group_id
read -p "Enter username: " username
read -p "Enter full name: " full_name
read -p "Enter shell : " shell

# Check if group already exists and create if not

if awk -F ":" '{print $1}' /etc/group | grep -q $group_name; then
    echo "Group $group_name already exists."
    echo "No need to recreate it"
else
    echo "Group $group_name does not exist."
    echo "Creating this group now ...."
    sudo groupadd $group_name -g $group_id
    echo "Successfully created the group : $group_name"
fi

# Check if User already exists and create if not

if awk -F ":" '{print $1}' /etc/passwd | grep -q $username; then
    echo "User $username already exists."
    echo "No need to recreate it"
else
    echo "User $username does not exist."
    echo "Creating this User now ...."
    sudo useradd $username -g $group_name -c "$full_name" -s $shell
    echo "Successfully created the user : $username"
fi

# Add the user group to sudoers file if does not already exist

if sudo cat /etc/sudoers | grep -q %$group_name; then
    echo "Group $group_name already exists in the sudoers file."
    echo "No need to readd it"
else
    echo "Group $group_name does not exist in the sudoers file."
    echo "Adding $group_name to the sudoers file now ...."
    sudo echo "%$group_name   ALL=(ALL:ALL) ALL" >> /etc/sudoers
    sudo echo "%$group_name        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
    echo "Successfully added the group $group_name to the sudoers file"
fi

# Switch to user and perform some commands to verify user has sudo privilege

sudo su $username <<EOF
whoami
id
sudo -l
EOF
