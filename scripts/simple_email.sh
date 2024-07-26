#!/usr/bin/env bash
#
# simple_email.sh
# Description:
# Sends email using tcp
#

# SMTP server configuration
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=465

# Email details
FROM_EMAIL="gareytwin1@gmail.com"
TO_EMAIL="gareytwin1@gmail.com"
SUBJECT="Test Email"
BODY="This is a test email sent using /dev/tcp in bash."

# Helper function to send commands to the SMTP server
send_command(){
    echo -ne "$1\r\n" >&3
    read -r response <&3
    echo "$response"
}

# Open a TCP connection to the SMTP server
exec 3<>/dev/tcp/$SMTP_SERVER/$SMTP_PORT

# Send SMTP commands
send_command "HELO localhost" 
send_command "MAIL FROM:<${FROM_EMAIL}>"
send_command "RCPT TO:<${TO_EMAIL}>"
send_command "DATA"
send_command "Subject: ${SUBJECT}\r\n\r\n${BODY}\r\n."
send_command "QUIT"

# Read the servers response and outputs to terminal
cat <&3

# Close the TCP connection
exec 3<&-
exec 3>&-

echo "Email send successfully."


