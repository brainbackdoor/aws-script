#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_EIP=(`aws ec2 describe-addresses --query "Addresses[].AllocationId" --output text`)


echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 Elastic IP 리스트${txtrst}"
printf "%s\n" "${TOTAL_EIP[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	for EIP in "${TOTAL_EIP[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${EIP} 를 제거 중입니다.${txtrst}"
		aws ec2 release-address --allocation-id ${EIP}
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


