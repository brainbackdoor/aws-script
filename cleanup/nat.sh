#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_NAT_GATEWAY=(`aws ec2 describe-nat-gateways --query "NatGateways[].NatGatewayId" --output text`)
NAT_GATEWAY_NAMES=(` aws ec2 describe-nat-gateways --query "NatGateways[].Tags[?Key=='Name'].Value" --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 NAT Gateway 리스트${txtrst}"
printf "%s\n" "${NAT_GATEWAY_NAMES[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	for NAT_INDEX in "${!TOTAL_NAT_GATEWAY[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${NAT_GATEWAY_NAMES[${NAT_INDEX}]} (${TOTAL_NAT_GATEWAY[${NAT_INDEX}]})를 제거 중입니다.${txtrst}"
		aws ec2 delete-nat-gateway --nat-gateway-id ${TOTAL_NAT_GATEWAY[${NAT_INDEX}]}
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


