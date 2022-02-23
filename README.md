# JAMF-IQVIA-Function-to-Check-LDAP-User-with-API

This Script will check if the Users in the local Mac are in LDAP with a 
JIM Server request through JAMP API. It will get the JIM Server name from jamf 
API request. 

## Jamf Variable Label Names

$4 -eq JAMF Instance URL (e.g. https://<YourJamf>.jamfcloud.com)
$5 -eq Your JAMF API Username
$6 -eq Your JAMF API Password

To test or use without using JAMF Policy you can just send 3 empty arguments 
to the script. See example below.
	(e.g. Function-to-Check-LDAP-User-with-API.sh empty1 empty2 empty3 $4 $5 $6)
