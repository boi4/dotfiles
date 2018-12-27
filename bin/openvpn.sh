#!/bin/bash
# Jan Fecht
# 4.12.2018

SUFFIX=tcp
#SUFFIX=udp

#COUNTRY_CODES_PATH=$HOME/Documents/Other/tables/country_codes.txt

CONFIG_FILES_PATH=$HOME/.config/nordvpn

#pwfile should have a line in the format: vpn.secrets.password:thepassword
USE_PWFILE=yes
PWFILE=$HOME/.config/nordvpn/pw
USERNAME=nordvpn1234@gmx.de



# Script starts here
CONFIG_NAMES=$(ls -1 $CONFIG_FILES_PATH | grep -v '^pw$' | cut -d . -f 1 | uniq)
CHOSEN_CONF=$(printf "$CONFIG_NAMES" | dmenu -i)

if [ $CHOSEN_CONF ]
then
	FILENAME=$(ls -1 $CONFIG_FILES_PATH | grep "$CHOSEN_CONF.*$SUFFIX")
	FULLPATH=$CONFIG_FILES_PATH/$FILENAME
	CONNECTION_NAME=${FILENAME%.*}
	echo $CONNECTION_NAME

	nmcli connection import --temporary type openvpn file $FULLPATH
	nmcli connection modify $CONNECTION_NAME "+vpn.data" "username = $USERNAME"

	if [[ $USE_PWFILE -eq "yes" ]]
	then
		nmcli connection up $CONNECTION_NAME passwd-file $PWFILE 
	else
		nmcli connection up $CONNECTION_NAME
	fi
fi


