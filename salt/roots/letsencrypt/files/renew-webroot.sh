#!/bin/sh

# Domain for which certificates are checked
domain="$1"
# Whether the Let's Encrypt Subscriber Agreement has been accepted
agree_tos="$2"

# Config and certificate file
webroot_file="/etc/letsencrypt/webroot-$domain.ini"
cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"
if [ ! -f "$webroot_file" ]; then
	printf "[ERROR] Couldn't find webroot file $webroot_file.\n"
    exit 1
fi
if [ ! -f "$cert_file" ]; then
	printf "[ERROR] Couldn't find certificate file $cert_file.\n"
    exit 1
fi

# Number of cert validity days left before the certificate renewal process is
# initiated
expiration_limit=30;
expiration_limit_sec=$(($expiration_limit * 24 * 60 * 60))

printf "Checking expiration date for %s...\n" "$domain"
expiration_date=$(openssl x509 -in "$cert_file" -text -noout\
                  | grep "Not After"\
                  | cut -d: -f2-)
expiration_timestamp=$(date -d "$expiration_date" +%s)
current_timestamp=$(date -d "now" +%s)

seconds_left=$(($expiration_timestamp - $current_timestamp))

# Don't do anything if the certificate will stay valid for some time.
if [ "$seconds_left" -gt "$expiration_limit_sec" ]; then
    exit 0
fi

days_left=$(($seconds_left / \( 24 * 60 * 60 \) ))
printf "[INFO ] Certificate for $domain will expire in %d days.\n"\
       $days_left

# Call letsencrypt
if [ "$agree_tos" != "agree_tos" ]; then
    printf "[ERROR] You must agree to the Let's Encrypt Subscriber Agreement\n"
    printf "[ERROR] to continue.  Run as \"%s %s agree_tos\" if that's the case.\n"\
           "$0" "$1"
fi

letsencrypt certonly                       \
            -a webroot                     \
            --non-interactive              \
            --test-cert                    \
            --renew-by-default             \
            --agree-tos                    \
            --config $webroot_file

if [ $? -gt 0 ]; then
    printf "[ERROR] Renewal process failed.\n"
    exit 1;
fi

printf "Renewal process was successful.  Reloading webserver configs... "
if systemctl reload nginx; then
    printf "DONE\n"
else
    printf "FAILED\n"
    printf "[ERROR] Could not reload nginx. Check the logs.\n"
    exit 2;
fi
printf "Renewal process finished for domain $domain\n"
exit 0
