
subjack -w "${1}/subdomains/subdomains.txt" -t 100 -timeout 60 -o "${1}/takeover/subjack.txt" --ssl -a -m

SubOver -l "${1}/subdomains/subdomains.txt" -a -t 100 -https -timeout 60 | tee -a "${1}/takeover/subover.txt"
