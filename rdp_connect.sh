!/bin/bash

# List of RDP servers
SERVERS=("nc-04.ielsmalta.com" "vdi-01.ielsmalta.com" "vdi-02.ielsmalta.com")

# User credentials (replace with your actual username)
#USERNAME="your_username"

# Loop indefinitely
while true; do
    for SERVER in "${SERVERS[@]}"; do
        echo "Connecting to $SERVER..."

        # Launch wlfreerdp with the current server
        wlfreerdp /v:"$SERVER" +clipboard /dynamic-resolution /sec:tls /cert-ignore /audio /f

        # Check the exit status of wlfreerdp
        if [ $? -eq 0 ]; then
            echo "Disconnected from $SERVER. Trying the next server..."
        else
            echo "wlfreerdp encountered an error with $SERVER. Moving to the next server..."
        fi
    done
done

