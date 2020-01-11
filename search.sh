#!/bin/bash

BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[32m"
RED="\e[30m"

HELP="
[+]USAGE:\t./search.sh  (OPTIONS) keyword ReconHome\n
-j (string) - search in javascript files
-e (string) - search in header files
-t (string) - search in  html files
-h - help
"

#writing code to check for expressions in html
searchhtml() {
 local WORD="${1}"
 for domain in $(ls "aquatone/html")
 do
  RES=$(cat aquatone/html/$domain | grep -inE "${WORD}")
  if [ $(echo $RES | wc -c) -ge 2 ]
  then
   echo -e "\n${BOLD}${GREEN}${domain}${NORMAL}"
   echo $RES
  fi
 done
}


#writing code to check for expressions in html
searchheader() {
 local WORD="${1}"
 for domain in $(ls "aquatone/headers")
 do
  RES=$(cat aquatone/headers/$domain | grep -iE "${WORD}")
  if [ $(echo $RES | wc -c) -ge 2 ]
  then
   echo -e "\n${BOLD}${GREEN}${domain}${NORMAL}"
   echo $RES
  fi
 done
}


#writing code to check for expressions in html

searchjs() {
 local WORD="${1}"
        for domain in $(ls scriptResponse)
        do
  for file in $(ls scriptResponse/$domain)
  do
                 RES=$(grep --color -inE "${WORD}" scriptResponse/$domain/$file)
                 if [ $(echo $RES | wc -c) -ge 2 ]
                  then
                    echo -e "\n${BOLD}${GREEN}${domain}/${file}${NORMAL}"
                    echo $RES
                 fi
done
 done
}


while getopts j:e:t:h OPTIONS
do
 case "${OPTIONS}" in
  j) searchjs "${OPTARG}" "target";;
  t) searchhtml "${OPTARG}" ;;
  e) searchheader "${OPTARG}" ;;
  h) echo -e "${HELP}" ;;
  *)
   echo "[+] Select a valid option.\n"
   echo -e "${HELP}"
   exit 1
  ;;
 esac
done