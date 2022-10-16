#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_SUBNET=(`aws ec2 describe-subnets --query "Subnets[].SubnetId" --output text`)
SUBNET_NAMES=(`aws ec2 describe-subnets --query "Subnets[].Tags[?Key=='Name'].Value" --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 Subnets 리스트${txtrst}"
printf "%s\n" "${SUBNET_NAMES[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	for SUBNET_INDEX in "${!TOTAL_SUBNET[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${SUBNET_NAMES[${SUBNET_INDEX}]} (${TOTAL_SUBNET[${SUBNET_INDEX}]})를 제거 중입니다.${txtrst}"
		aws ec2 delete-subnet --subnet-id ${TOTAL_SUBNET[${SUBNET_INDEX}]}
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


