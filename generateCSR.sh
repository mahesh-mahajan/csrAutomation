#!/bin/bash
#
# Maintained by: Mahesh Mahajan
# Github: https://github.com/mahesh-mahajan/
# Github Repository: https://github.com/mahesh-mahajan/csrAutomation/
#
## Shell script to generate CSR with Subject Alternate Name values.
#
## Usage Exmaples
## sh generateCSR.sh www.example.com
## sh generateCSR.sh subdomain.example.com
#
## TO DO
## - Set multiple SAN values from the input. (i.e.: generateCSR.sh www.example.com subdomain.example.com)
## - Running script with above inputs should set www.example.com as CN and dubdomain.example.com as DNS.1
#
## VARIABLES
#
CP=$(which cp)
MKDIR=$(which mkdir)
SED=$(which sed)
OPENSSL=$(which openssl)
WHO=$(whoami)
#
## Shell Script Code
#
echo
echo ""$WHO" is running generateCSR.sh"
if [ "" = "$1" ]; then
   echo "To execute generateCSR.sh you must provide domain or subdomain name. For example: www.example.com or subdomain.example.com"
   exit 1
fi
echo
echo "CN provided for the certificate is $1"
echo
## Create folder based on the domain or subdomain name provided.
echo "Creating folder '$1_csr under the home directory of current user'"
echo
"$MKDIR" -p ~/$1_csr
echo "Folder ready '`echo ~/$1_csr`'"
## Setting up openssl custom configuration template.
echo
echo "Setting up custom openssl configuration"
echo
"$CP" -rfv opensslCustom.cfg ~/$1_csr/$1.cfg
echo
## Modify custom openssl configuration template to add domain or subdomain name provided in the input.
echo
echo "Updating CN ($1) and SAN ($1) values in the openssl configuration based on the input provided."
echo
"$SED" -i 's/www.example.com/'$1'/g' ~/$1_csr/$1.cfg
echo
## Generate 2048 bit RSA private key.
echo "Generating RSA 2048 Private Key"
echo
"$OPENSSL" genrsa -out ~/$1_csr/$1.key 2048
echo
## Generate Certificate Signing Request
echo "Generating Certificate Signing Request."
echo
echo "Subject information is being picked up from '~/$1_csr/$1.cfg'"
echo
echo "You will be prompted Subject Information where you can makes changes to the default values."
echo
"$OPENSSL" req -config ~/$1_csr/$1.cfg -new -key ~/$1_csr/$1.key -out ~/$1_csr/$1.csr
echo
## Validate Certificate Signing Request
echo "Printing Subject Information, SAN (DNS) & Extended Key Usage values for verification."
echo
"$OPENSSL" req -in ~/$1_csr/$1.csr -noout -text | egrep 'Subject:|DNS|Usage|TLS'
echo
## Validate Checksum values of both private key and Certificate Signing Request.
echo
echo "SHA256SUM verification"
echo
echo "Checksum values of both Private Key and Certificate Signing Request should be identical"
echo
"$OPENSSL" pkey -in ~/$1_csr/$1.key -pubout -outform pem | sha256sum
"$OPENSSL" req -in ~/$1_csr/$1.csr -pubkey -noout -outform pem | sha256sum
echo
echo "Please share Certificate Signing Request with concern team for further processing"
echo
echo "Certificate Signing Request File Path: `echo ~/$1_csr/$1.csr`"
echo
echo "Thank You!"
