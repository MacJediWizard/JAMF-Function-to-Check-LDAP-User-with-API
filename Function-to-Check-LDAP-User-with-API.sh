#!/bin/bash

##########################################################################################
# General Information
##########################################################################################
#
#	Script created By William Grzybowski February 22, 2022
#
#	Version 1.0	- Initial Creation of Script.
#
#	This Script will check if the Users in the local Mac are in LDAP with a 
#	JIM Server request through JAMP API.
#
#	Jamf Variable Label names
#
#	$4 -eq JAMF Instance URL (e.g. https://<YourJamf>.jamfcloud.com)
#	$5 -eq Your JAMF JIM Server Name
#	$6 -eq Your JAMF API Username
#	$7 -eq Your JAMF API Password
#
#	To test or use without using JAMF Policy you can just send 3 empty arguments 
#	to the script. See example below.
#	(e.g. Function-to-Check-LDAP-User-with-API.sh empty1 empty2 empty3 $4 $5 $6 $7)
#
##########################################################################################


##########################################################################################
# License information
##########################################################################################
#
#	Copyright (c) 2022 William Grzybowski
#
#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:
#
#	The above copyright notice and this permission notice shall be included in all
#	copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	SOFTWARE.
#
##########################################################################################

# JAMF API Information
URL="${4}"
JIMServerName="${5}"
username="${6}"
password="${7}"

# Variablles
listUsers="$(/usr/bin/dscl . list /Users UniqueID | awk '$2 > 1000 {print $1}') FINISHED"

until [ "$netName" == "FINISHED" ]; do
	
	for netName in $listUsers; do
		
		if [ "$netName" = "FINISHED" ]; then
			/bin/echo "Finished checking Users in List of Users on Mac."
			exit 0
		fi
		
		echo ${netName}
		# Set up Function to process LDAP Request
		echo "Checking to verify if ${netName} is in LDAP User before we process."
		verifyUserFromLDAP=(`/usr/bin/curl "$URL/JSSResource/ldapservers/name/${JIMServerName}/user/${netName}" \
								--silent \
								--request GET \
								--user "$username:$password" \
								| /usr/bin/xpath -e "//ldap_users/ldap_user/username/text()" 2> /dev/null`)
		
		if [[ ${verifyUserFromLDAP} != "" ]]; then
			
			echo "We found ${netName} in LDAP!"
			
		else
			
			echo "User ${netName} in not in LDAP!"
			
		fi
		
	done
	
done
