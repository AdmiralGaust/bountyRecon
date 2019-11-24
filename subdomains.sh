
##Subfinder
subfinder -dL ${1} -o "${2}/subfinder.txt" -t 100 -recursive 

##Amass
amass enum -config "${3}" -o "${2}/amass.txt" -df ${1}

