#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_SG=(`aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --output text`)
SG_NAMES=(`aws ec2 describe-security-groups --query "SecurityGroups[].GroupName" --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 Security Group 리스트 (default는 제외하고 삭제합니다.) ${txtrst}"
printf "%s\n" "${SG_NAMES[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	for SG_INDEX in "${!TOTAL_SG[@]}"; do 
		if [ ${SG_NAMES[${SG_INDEX}]} != 'default' ]; then
			echo -e ""
			echo -e "${txtred}>> ${SG_NAMES[${SG_INDEX}]} (${TOTAL_SG[${SG_INDEX}]})를 제거 중입니다.${txtrst}"
			aws ec2 delete-security-group --group-id ${TOTAL_SG[${SG_INDEX}]}
		fi
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


