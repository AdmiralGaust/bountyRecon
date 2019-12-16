
function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}


##Subfinder
subfinder -dL ${1} -o "${2}/subfinder.txt" -t 100 -recursive 

##Amass

amass_home=$(getValueFromConfig "amass_home") 
amass_config_path=$(getValueFromConfig "amass_config_path") 

${amass_home}/amass enum -config "${amass_config_path}" -o "${2}/amass.txt" -df ${1}

