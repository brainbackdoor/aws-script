#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_EC2=(`aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --output text`)
TOTAL_EC2_TAGS=(`aws ec2 describe-instances --query "Reservations[].Instances[].Tags[?Key=='Name'].Value" --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 EC2 리스트${txtrst}"
printf "%s\n" "${TOTAL_EC2_TAGS[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then
	echo -e "${txtred}>> EC2를 제거 중입니다.${txtrst}"
	aws ec2 terminate-instances --instance-ids ${TOTAL_EC2[@]}

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


