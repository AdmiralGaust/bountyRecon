
function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}

SubOver_home=$(getValueFromConfig "SubOver_home") 

subjack -w "${1}/subdomains/subdomains.txt" -t 100 -timeout 60 -o "${1}/takeover/subjack.txt" --ssl -a -m

"${SubOver_home}/SubOver" -l "${1}/subdomains/subdomains.txt" -a -t 100 -https -timeout 60 | tee -a "${1}/takeover/subover.txt"