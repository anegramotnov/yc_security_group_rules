#!/bin/bash

######################### Environment settings ###############################

# SECURITY_GROUP_NAME=my_security_group

##############################################################################


[[ -z "$SECURITY_GROUP_NAME" ]] && echo "\$SECURITY_GROUP_NAME variable must be set" && exit 1


detect_ip() {

	DETECTED_IP=$(curl --silent http://ipinfo.io/ip)

	RET_VAL=$?
	if [[ $RET_VAL -ne 0 ]]
	then
		echo "IP detection service is not available"
		exit 1
	else
		echo "Detected your public IP: $DETECTED_IP"
	fi
}



get() {
	DESCRIPTION=$1

	ALL_RULES=$(yc vpc security-group --name $SECURITY_GROUP_NAME get)
	
	if [[ -z $DESCRIPTION ]]
	then
		echo "$ALL_RULES"
	else
		FILTERED_RULES=$(echo "$ALL_RULES" | grep -B 1 -A 8 "  description: "$DESCRIPTION"$")
		echo "$FILTERED_RULES"
	fi
}


new() {	
	DESCRIPTION=$1 
	CIDR=$2
	DEFAULT_MASK=32

	if [[ -z "$CIDR" ]]
	then
		detect_ip
		CIDR="$DETECTED_IP/$DEFAULT_MASK"
	fi
	yc vpc security-group --name $SECURITY_GROUP_NAME update-rules --add-rule "direction=ingress,from-port=0,to-port=65535,protocol=Any,v4-cidrs=[$CIDR],description=$DESCRIPTION"
	RET_VAL=$?
	if [[ $RET_VAL -ne 0 ]]
	then
		exit 1
	else
		echo "Rule with CIDR=$CIDR, description='$DESCRIPTION' succesfully created"
	fi

}

delete() {
	DESCRIPTION=$1

	# get RULE_ID by DESCRIPTION
	RULE_ID=$(yc vpc security-group --name $SECURITY_GROUP_NAME get | grep -B 1 "  description: "$DESCRIPTION"$" | head -1 | awk '/^- id:/ { print $3 }')

	[[ -z "$RULE_ID" ]] && echo "Rule '$DESCRIPTION' not found" && exit 1

	yc vpc security-group update-rules --name $SECURITY_GROUP_NAME --delete-rule-id "$RULE_ID"
	RET_VAL=$?
	if [[ $RET_VAL -ne 0 ]]
	then
		exit 1
	else
		echo "Rule '$DESCRIPTION' succesfully deleted"
	fi
}


COMMAND=$1


case "$COMMAND" in
	get)
		get $2
		;;
	new)
		[[ -z "$2" ]] && echo "Required argument DESCRIPTION is empty" && exit 1
		new $2 $3
		;;
	del)
		[[ -z "$2" ]] && echo "Required argument DESCRIPTION is empty" && exit 1
		delete $2
		;;

	upd)
		[[ -z "$2" ]] && echo "Required argument DESCRIPTION is empty" && exit 1
		delete $2
		new $2 $3
		;;
	*)
		echo
		echo "CLI for management of security-group rules in Yandex Cloud"
		echo
		echo "USAGE:"
		echo
		echo "  $0 COMMAND [ARG1] ... [ARGN]"
		echo
		echo "COMMANDS:"
		echo
		echo "  get [DESCRIPTION]           Get all rules or filtered by DESCRIPTION"
		echo
		echo "  new DESCRIPTION [CIDR]      Create new rule with DESCRIPTION and CIDR"
		echo "                              or your public IP (if CIDR was not specified)"
		echo
		echo "  del DESCRIPTION             Delete one rule founded by DESCRIPTION"
		echo
		echo "  upd DESCRIPTION [CIDR]      Delete old rule by description and create"
		echo "                              new rule with the same description and CIDR"
		echo "                              or your public IP (if CIDR was not specified)"
		echo
		echo "ARGUMENTS:"
		echo
		echo "  DESCRIPTION                 Description field of security-group rule"
		echo
		echo "  CIDR                        CIDR in format 'ip/mask' (eg '10.0.0.1/32')"
		exit 1
		;;
esac

