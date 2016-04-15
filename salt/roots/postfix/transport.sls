# Transport map for local recipients
/etc/postfix/mailbox_transport:
  cmd.run:
    # Use LMTP for 'regular' users, the default (local(8)) otherwise.  Users
    # are assumed to be regular users if their uid is 500 or greater and their
    # home dir is in /home
    - name: >
          awk -F: '$3 >= 500 && $6 ~ /^\/home\// { print $1,"lmtp:unix:private/dovecot-lmtp" }'
          /etc/passwd > /etc/postfix/mailbox_transport
    - unless: test /etc/postfix/mailbox_transport -nt /etc/passwd

postmap /etc/postfix/mailbox_transport:
  cmd.wait:
    - cwd: /
    - watch:
        - cmd: /etc/postfix/mailbox_transport
