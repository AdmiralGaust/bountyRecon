#!/bin/bash

##Script to Automate Bug Bounty Recon

if ! [[ -f ${1} ]] ;then
	echo "[!] Please pass the required arguments :"
	echo "		usage : ./bounty.sh [list of domains]" 
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

subfinder -dL ${1} -o "${Recon_Home}/subdomains/subfinder.txt" -t 100 -recursive

##Amass

amass_home=$(getValueFromConfig "amass_home")
echo "${amass_home}/amass" -config config.ini -o "${Recon_Home}/subdomains/amass.txt" -d savedroid.com"

