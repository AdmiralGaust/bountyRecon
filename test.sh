
function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}


##Subfinder
subfinder -dL ${1} -o "${2}/subfinder.txt" -t 100 -recursive 

##Amass

amass_home=$(getValueFromConfig "amass_home") 
amass_config_path=$(getValueFromConfig "amass_config_path") 

${amass_home}/amass enum -config "${amass_config_path}" -o "${2}/amass.txt" -df ${1}





#!/bin/bash
mkdir scripts
mkdir scriptResponse


function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}


for x in $(ls "${1}/aquatone/html/")
do
        END_POINTS=$(cat "${1}/aquatone/html/$x" | grep -Eoi "src\s*=\s*[\"\']?.*\.js"|cut -d '=' -f 2|sed "s/['\"]//g"|sed "s/\s//g")
        for end_point in $END_POINTS
        do
                len=$(echo $end_point | grep "http" | wc -c)
                mkdir "scriptResponse/$x/"
                URL=$end_point
                if [ $len == 0 ]
                then
                        URL="https://$x$end_point"
                fi
                file=$(basename $end_point)
                curl -X GET $URL -L > "scriptResponse/$x/$file"
                echo $URL >> "scripts/$x"
        done
done


echo https__cms_axisbank_co_in__da39a3ee5e6b4b0d.html|sed "s/__/\/\//"|sed "s/_/./g"|sed "s/\.\./\`/"|cut -d "\`" -f 1
