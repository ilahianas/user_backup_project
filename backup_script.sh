#!/bin/bash

# Configuration
BACKUP_DIR="/var/backups"
RETENTION_DAYS=7

# Function to add a user
add_user() {
    local username="$1"
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        sudo useradd "$username"
        echo "User $username added."
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

# Function to list all users
list_users() {
    cut -d: -f1 /etc/passwd
}

# Function to backup a directory
backup_directory() {
    local dir_to_backup="$1"
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

    if [ -d "$dir_to_backup" ]; then
        tar -czf "$backup_file" -C "$dir_to_backup" .
        echo "Backup of $dir_to_backup created at $backup_file."
    else
        echo "Directory $dir_to_backup does not exist."
    fi
}

# Function to clean up old backups
cleanup_backups() {
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
    echo "Old backups deleted."
}

# Main menu function
show_menu() {
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. List Users"
    echo "4. Backup Directory"
    echo "5. Clean Up Backups"
    echo "6. Exit"
}

# Execute user choice
execute_choice() {
    case $1 in
        1)
            read -p "Enter username to add: " username
            add_user "$username"
            ;;
        2)
            read -p "Enter username to delete: " username
            delete_user "$username"
            ;;
        3)
            list_users
            ;;
        4)
            read -p "Enter directory to backup: " dir_to_backup
            backup_directory "$dir_to_backup"
            ;;
        5)
            cleanup_backups
            ;;
        6)
            exit 0
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Main script execution loop
while true; do
    show_menu
    read -p "Choose an option [1-6]: " choice
    execute_choice "$choice"
done

