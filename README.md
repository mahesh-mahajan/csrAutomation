# csrAutomation
Automate your Certificate Signing Request (CSR) for SSL certificates.

Usage:

Place both generateCSR.sh & opensslCustom.cfg in the same directory.
For example: 

Base Path: ~/csrAutomation/
Files: 
~/csrAutomation/generateCSR.sh
~/csrAutomation/opensslCustom.cfg

Change permissions.

chmod +x generateCSR.sh

Executing shell script with the domain name.

$ sh generateCSR.sh mahesh.com

This should provide you following folder & files.

~/mahesh.com
~/mahesh.com/mahesh.com.cfg
~/mahesh.com/mahesh.com.key
~/mahesh.com/mahesh.com.csr
