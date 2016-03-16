#!/bin/sh

verbosity=6

while getopts ":q" opt; do
    case "$opt" in
        q)
            verbosity=$(($verbosity - 1))
            ;;
        \?)
            printf "Invalid option: -%s\n" $opt
            ;;
    esac
done
shift $((OPTIND -1))

info ()
{
    if [ "$verbosity" -ge 6 ]; then
        printf "[INFO  ] %s\n" "$@"
    fi
}

notice ()
{
    if [ "$verbosity" -ge 5 ]; then
        printf "[NOTICE] %s\n" "$@"
    fi
}

error ()
{
    if [ "$verbosity" -ge 3 ]; then
        printf "[ERROR ] %s\n" "$@"
    fi
}

# Domain for which certificates are checked
domain="$1"
# Whether the Let's Encrypt Subscriber Agreement has been accepted
agree_tos="$2"

# Config and certificate file
config_file="/etc/letsencrypt/config-$domain.ini"
cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"
if [ ! -f "$config_file" ]; then
	error "Couldn't find config file $config_file."
    exit 1
fi
if [ ! -f "$cert_file" ]; then
	error "Couldn't find certificate file $cert_file."
    exit 1
fi

# Number of cert validity days left before the certificate renewal process is
# initiated
expiration_limit=30;
expiration_limit_sec=$(($expiration_limit * 24 * 60 * 60))

info "Checking expiration date for $domain..."

expiration_date=$(openssl x509 -in "$cert_file" -text -noout\
                  | grep "Not After"\
                  | cut -d: -f2-)
expiration_timestamp=$(date -d "$expiration_date" +%s)
current_timestamp=$(date -d "now" +%s)
seconds_left=$(($expiration_timestamp - $current_timestamp))
days_left=$(($seconds_left / \( 24 * 60 * 60 \) ))

info "Certificate for $domain will expire in ${days_left} days."
# Don't do anything if the certificate will stay valid for some time.
if [ "$seconds_left" -gt "$expiration_limit_sec" ]; then
    info "No update necessary.  Exiting..."
    exit 0
fi


# Call letsencrypt
if [ "$agree_tos" != "agree_tos" ]; then
    error "You must agree to the Let's Encrypt Subscriber Agreement"
    error "to continue.  Run as ${@} agree_tos\" if that's the case."\
fi

letsencrypt certonly                       \
            -a webroot                     \
            --non-interactive              \
            --renew-by-default             \
            --agree-tos                    \
            --config $config_file

if [ $? -gt 0 ]; then
    error "Renewal process failed."
    exit 1;
fi

notice "Renewal process was successful."
info "Reloading webserver configs... "
if systemctl reload nginx; then
    info "DONE"
else
    error "FAILED"
    error "Could not reload nginx. Check the logs."
    exit 2;
fi
notice "Renewal process finished for domain $domain."
exit 0
