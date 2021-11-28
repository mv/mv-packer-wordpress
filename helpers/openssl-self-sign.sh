#!/bin/bash


#   -subj   "/C=BR/ST=SP/L=SaoPaulo/O=CompanyName/OU=Org/CN=www.example.com"

openssl req -x509       \
    -newkey rsa:4096    \
    -subj   "/C=BR/ST=SP/L=SaoPaulo/O=CompanyName/OU=Org/CN=localhost" \
    -out    ./localhost-selfsigned-cert.pem    \
    -keyout ./localhost-selfsigned-priv.key    \
    -nodes  \
    -days 3650  # 10y


# time openssl dhparam -out dhparam-2048.pem 2048
# time openssl dhparam -out dhparam-4096.pem 4096


#   SSLEngine on
#
#   SSLCertificateFile    /etc/ssl/certs/localhost-selfsigned-cert.pem
#   SSLCertificateKeyFile /etc/ssl/private/localhost-selfsigned-priv.key


