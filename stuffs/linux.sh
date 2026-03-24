#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root or with sudo."
  exit 1
fi

# Define the username
USERNAME="backup"

# Create the user without a home directory
useradd -M -s /bin/bash "$USERNAME" 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to create user '$USERNAME'. The user may already exist."
  exit 1
fi

# Grant sudo privileges to the user
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to grant sudo privileges to '$USERNAME'."
  exit 1
fi

# Set proper permissions for the sudoers file
chmod 440 /etc/sudoers.d/$USERNAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to set permissions for the sudoers file."
  exit 1
fi