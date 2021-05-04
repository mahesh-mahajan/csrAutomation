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
echo "Running generateCSR.sh"
echo
#
if [ "" = "$1" ]; then
   echo "To execute generateCSR.sh you must provide domain or subdomain name. For example: www.example.com or subdomain.example.com"
   exit 1
fi
#
echo
echo "Enter the domain or subdomain name:$1"
echo
## Create folder based on the domain or subdomain name provided
echo "Creating folder '/c/localWork/CA/$1'"
echo
mkdir -p /c/localWork/CA/$1
echo
#
#
## Copy openssl custom configuration template
#
echo
echo "Setting up custom openssl configuration"
echo
#cp -rfv /c/localwork/CA/script/sample.cfg /c/localwork/CA/$1/$1.cfg

cp -rfv /c/localwork/CA/script/opensslCustom.cfg /c/localwork/CA/$1/$1.cfg

echo
#
## Modify custom openssl configuration template to add domain or subdomain name provided in the input.
#
echo
echo "Updating CN and SAN values in the openssl configuration based on the input provided."
echo
#
sed -i 's/www.example.com/'$1'/g' /c/localwork/CA/$1/$1.cfg
echo
#
## Generate 2048 bit RSA private key.
#
echo "Generating RSA 2048 Private Key"
#
echo
openssl genrsa -out /c/localwork/CA/$1/$1.key 2048
echo
#
## Generate Certificate Signing Request
#
echo "Generating Certificate Signing Request."
echo "Subject information is being picked up from '/c/localwork/CA/$1/$1.cfg'"
openssl req -config /c/localwork/CA/$1/$1.cfg -new -key /c/localwork/CA/$1/$1.key -out /c/localwork/CA/$1/$1.csr
echo
#
## Validate Certificate Signing Request
echo "Printing Subject Information and SAN values for verification."
echo
openssl req -in /c/localwork/CA/$1/$1.csr -noout -text | grep "Subject"
openssl req -in /c/localwork/CA/$1/$1.csr -noout -text | grep "DNS"
echo
#
## Validate Checksum values of both private key and Certificate Signing Request.
#
echo
echo "SHA256SUM verification"
echo "Checksum values of both Private Key and Certificate Signing Request should be identical"
echo
openssl pkey -in /c/localwork/CA/$1/$1.key -pubout -outform pem | sha256sum
openssl req -in /c/localwork/CA/$1/$1.csr -pubkey -noout -outform pem | sha256sum
echo
echo "Please share Certificate Signing Request with concern team for further processing"
echo
echo "Certificate Signing Request File Path: /c/localwork/CA/$1/$1.csr"
echo
echo "Thank You!"
