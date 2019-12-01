
function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}


amass_home=$(getValueFromConfig "amass_home") 

##Subfinder
subfinder -dL ${1} -o "${2}/subfinder.txt" -t 100 -recursive 

##Amass
${amass_home}/amass enum -config "${3}" -o "${2}/amass.txt" -df ${1}

