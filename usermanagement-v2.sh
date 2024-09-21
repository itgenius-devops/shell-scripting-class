#!/bin/bash

read -p "Input the new group Name to Create: " usergroup
read -p "Input the new user name to Create: " username
read -p "Input the Full Name of the New User: " full_name
read -p "Input the Shell to be assigned to the New User: " shell
read -p "Input the group id to be assigned to the new group: " group_id
existing_group=`cat /etc/group | grep $usergroup | awk -F ":" '{print $1}'`
existing_username=`cat /etc/passwd | grep $username | awk -F ":" '{print $1}'`
existing_sudoers=`cat /etc/sudoers | grep %$usergroup | awk -F " " '{print $1}' | uniq`
sudoers_group=%$usergroup



if [ "$usergroup" = "$existing_group" ]; then
    echo "Group $usergroup already exists."
    echo "No need to recreate it"
else
    echo "Group $usergroup does not exist."
    echo "Creating this group now ...."
    sudo groupadd $usergroup -g $group_id
    echo "Successfully created the group : $usergroup"
fi

if [ "$username" = "$existing_username" ]; then
    echo "User $username already exists."
    echo "No need to recreate it"
else
    echo "User $username does not exist."
    echo "Creating this User now ...."
    sudo useradd $username -g $usergroup -c "$full_name" -s $shell
    echo "Successfully created the user : $username"
fi


# Add the user group to sudoers file if does not already exist

if [ "$sudoers_group" = "$existing_sudoers" ]; then
    echo "Group $usergroup already exists in the sudoers file."
    echo "No need to readd it"
else
    echo "Group $usergroup does not exist in the sudoers file."
    echo "Adding $usergroup to the sudoers file now ...."
    sudo echo "%$usergroup   ALL=(ALL:ALL) ALL" >> /etc/sudoers
    sudo echo "%$usergroup        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
    echo "Successfully added the group $usergroup to the sudoers file"
fi

# Switch to user and perform some commands to verify user has sudo privilege

sudo su $username <<EOF
whoami
id
sudo -l
EOF
