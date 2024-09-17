#!/bin/bash

# Script Configuration
BACKUP_DIR="/var/backups"
USER_LIST="/tmp/user_list.txt"

# Function to create a user
create_user() {
    local username="$1"
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        sudo useradd "$username"
        echo "User $username created."
    fi
}

# Function to delete a user
delete_user() {
    local username="$1"
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "User $username deleted."
    else
        echo "User $username does not exist."
    fi
}

# Function to backup directories
backup_directories() {
    local dir="$1"
    local timestamp=$(date +"%Y%m%d%H%M")
    local backup_file="${BACKUP_DIR}/backup_${timestamp}.tar.gz"

    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        return
    fi

    mkdir -p "$BACKUP_DIR"
    tar -czf "$backup_file" "$dir"
    echo "Backup of $dir completed: $backup_file"
}

# Main script execution
case "$1" in
    create)
        if [ -z "$2" ]; then
            echo "Usage: $0 create <username>"
            exit 1
        fi
        create_user "$2"
        ;;
    delete)
        if [ -z "$2" ]; then
            echo "Usage: $0 delete <username>"
            exit 1
        fi
        delete_user "$2"
        ;;
    backup)
        if [ -z "$2" ]; then
        echo "Usage: $0 backup <directory>"
            exit 1
        fi
        backup_directories "$2"
        ;;
    *)
        echo "Usage: $0 {create|delete|backup} <arguments>"
        exit 1
        ;;
esac
