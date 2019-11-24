#!/bin/bash

##Script to Automate Bug Bounty Recon

if ! [[ ${1} && ${2} ]] ;then
	echo -e "\n[!] Please pass the required arguments :"
	echo -e "\tusage : ./bountyRecon.sh TARGET_NAME [list of domains]\n" 
	exit
fi

if ! [[ -f ${2} ]]; then
	echo -e "\n[-] File does not exist : ${2}\n"
	exit
fi


######Reading Config File

function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}

Recon_Home=`pwd`"/${1}"
domains=${2}
amass_config_path=$(getValueFromConfig "amass_config_path") 

start_time=`date "+%d%m%y_%H%M%S"`
mkdir -p "${Recon_Home}/logs"

logfile="${Recon_Home}/logs/${start_time}.log"



######Subdomain Enumeration########

mkdir -p "${Recon_Home}/subdomains"

echo -e "\n[+] Started Subdomain Enumeration at ${start_time}\n"| tee -a ${logfile}

./subdomains.sh $domains "${Recon_Home}/subdomains" "${amass_config_path}"

echo -e "[+] Subdomain Enumeration Finished at `date '+%d%m%y_%H%M%S'`\n"| tee -a ${logfile}

cat "${Recon_Home}/subdomains/subfinder.txt" "${Recon_Home}/subdomains/amass.txt" |sed  "/^[\.*]/d" |sort -u > "${Recon_Home}/subdomains/subdomains.txt"



########Testing for Alive and Resolvable domains####

echo "[+] Checking for alive domains..\n" | tee -a ${logfile}

cat "${Recon_Home}/subdomains/subdomains.txt" | httprobe -p http:8080 https:8080 https:8443 http:8000 https:8000 -c 50| tee -a "${Recon_Home}/subdomains/alive.txt"

echo "[+] Finished Checking Alive domains\n" | tee -a ${logfile}

massdns_home=$(getValueFromConfig "massdns_home")

echo "[+] Checking for Resolvable domains..\n" | tee -a ${logfile}

${massdns_home}/massdns -r ${massdns_home}/lists/resolvers.txt -o S -w "${Recon_Home}/subdomains/massdns.txt" "${Recon_Home}/subdomains/subdomains.txt"

echo "[+] Finished Checking Resolvable domains\n" | tee -a ${logfile}

cat "${Recon_Home}/subdomains/massdns.txt" |cut -d " " -f 1|sed "s/\.$//"|sort -u > "${Recon_Home}/subdomains/resolvable.txt"



##########Screenshot the target with eyewitness######




