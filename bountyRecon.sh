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



#######Initializing variables

TARGET_NAME=${1}
domains=${2}

Recon_Home=`pwd`"/${TARGET_NAME}"
amass_config_path=$(getValueFromConfig "amass_config_path") 


mkdir -p "${Recon_Home}/logs"

start_time=`date "+%d%m%y_%H%M%S"`
logfile="${Recon_Home}/logs/${start_time}.log"



######Subdomain Enumeration########

mkdir -p "${Recon_Home}/subdomains"

echo -e "\n[+] Started Subdomain Enumeration at ${start_time}"| tee -a ${logfile}

echo $domains | parallel  --citation ./subdomains.sh {} "${Recon_Home}/subdomains"

echo -e "[+] Subdomain Enumeration Finished at `date '+%d%m%y_%H%M%S'`"| tee -a ${logfile}

cat "${Recon_Home}/subdomains/subfinder.txt" "${Recon_Home}/subdomains/amass.txt" |sed  "/^[\.*]/d" |sort -u > "${Recon_Home}/subdomains/subdomains.txt"



########Testing for Alive and Resolvable domains####

#echo "[+] Checking for alive domains..\n" | tee -a ${logfile}

#cat "${Recon_Home}/subdomains/subdomains.txt" | httprobe -p http:8080 https:8080 https:8443 http:8000 https:8000 -c 50| tee -a "${Recon_Home}/subdomains/alive.txt"

#echo "[+] Finished Checking Alive domains\n" | tee -a ${logfile}

massdns_home=$(getValueFromConfig "massdns_home")

echo -e "[+] Checking for Resolvable domains.." | tee -a ${logfile}

${massdns_home}/bin/massdns -r ${massdns_home}/lists/resolvers.txt -o S -w "${Recon_Home}/subdomains/massdns.txt" "${Recon_Home}/subdomains/subdomains.txt"

echo -e "[+] Finished Checking Resolvable domains" | tee -a ${logfile}

cat "${Recon_Home}/subdomains/massdns.txt" |cut -d " " -f 1|sed "s/\.$//"|sort -u > "${Recon_Home}/subdomains/resolvable.txt"



##########Screenshot the target with aquatone######

mkdir -p "${Recon_Home}/aquatone"

echo -e "[+] Attempting Screenshot for the target subdomains..." | tee -a ${logfile}

aquatone_home=$(getValueFromConfig "aquatone_home")
cat "${Recon_Home}/subdomains/subdomains.txt"| ${aquatone_home}/aquatone -out ${Recon_Home}/aquatone -http-timeout 30000 -scan-timeout 30000 -screenshot-timeout 60000

echo -e "[+] Screenshot Finished for subdomains" | tee -a ${logfile}


#######Extract javascript files and urls

echo -e "[+] Extracting javascript from html source" | tee -a ${logfile}

./jsextractor.sh "${Recon_Home}"

echo -e "[+] javascript extracted successfully" | tee -a ${logfile}


########Subdomain takeover

mkdir -p "${Recon_Home}/takeover"

echo $Recon_Home | parallel  --citation ./takeover.sh {}

###TO do list

#Test put method on all subdomains
#Check hidden files and other important files like .git, .DS_Store and swagger-ui.html on all subdomains
#Masscan the target
