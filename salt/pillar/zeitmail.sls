zeitmail:
  ## The mail address or system user to which important system mails are
  ## forwarded.  This includes mail to RFC 2142 addresses (info, abuse,
  ## trouble, noc, security, postmaster, and hostmaster) as well as admin,
  ## root, and nobody.  If this is not specified or empty, all mails will be
  ## sent to the root user.  It is STRONGLY RECOMMENDED that this is set to a
  ## system user.
  #admin_mail:

  ## (APPROXIMATE) bits of security used for encryption.  A value between 128
  ## and 192 bits should be specified here.
  bits_security: 128

  ## Diffie-Hellman parameters.
  dh:
    ## Whether to generate custom DH parameters.  This can take quite a long
    ## time.  Self-generated parameters are regenerated once a month.
    custom_parameters: no

  ## Domain Key Identified Mail signing requires additional TXT records in
  ## DNS.  This is not always possible with some hosts.
  dkim:
    sign: yes

  ## Domain settings
  domain:
    ## Domain name for which a mail-server should be set up (e.g. example.com).
    mail: {{salt['grains.get']('domain')}}
    ## Webmail domain.  The webmail site will be made available under this domain.
    webmail: {{'mail.' ~ salt['grains.get']('domain')}}
    ## List of additional domains on this server.  Relevant for certificates.
    additional:
      - {{'www.' ~ salt['grains.get']('domain')}}

  ## SSL/TLS certificate settings
  ssl:
    certificate:
      ## How SSL certificates should be obtained.  Can be any of 'letsencrypt',
      ## 'self-signed', or 'manual'.  Make sure to also set the file and
      ## key_file properties when chosing 'manual'.
      ca: self-signed
      ## The file containing the public key. (File must include the full certificate
      ## chain).
      file: /etc/ssl/certs/{{grains['domain']}}.pem
      ## The file containing the private key.
      key_file: /etc/ssl/private/{{grains['domain']}}.key

  ## Let's Encrypt settings
  letsencrypt:
    # Email to use for Let's Encrypt account
    email: {{'postmaster@' ~ salt['grains.get']('domain')}}
    # Set this to True ONLY IF you agree to the Let's Entrypt Subscriber
    # Agreement
    # <https://letsencrypt.org/documents/LE-SA-v1.0.1-July-27-2015.pdf>
    # See <https://letsencrypt.org/repository> for the Let's Encrypt
    # Policy and Legal Repository.
    agree_tos: no
