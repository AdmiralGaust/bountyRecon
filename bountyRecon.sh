#!/bin/bash

##Script to Automate Bug Bounty Recon

if ! [[ -f ${1} ]] ;then
	echo "[!] Please pass the required arguments :"
	echo "		usage : ./bountyRecon.sh [list of domains]" 
	exit
fi


######Reading Config File

function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}


######Subdomain Enumeration######

Recon_Home=$(getValueFromConfig "Recon_Home")

mkdir -p "${Recon_Home}/subdomains"

##Subfinder

#grep "\S" ${1}| while read domain; do
#	subfinder -dL ${domain} -o ${Recon_Home}/subdomains/$domain -t 100 -recursive
#done

echo subfinder -dL ${1} -o "${Recon_Home}/subdomains/subfinder.txt" -t 100 -recursive

##Amass
amass_config_path=$(getValueFromConfig "amass_config_path") 
echo amass enum -config ${amass_config_path} -o "${Recon_Home}/subdomains/amass.txt" -df ${1}

