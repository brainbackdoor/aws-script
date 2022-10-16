#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_RT=(`aws ec2 describe-route-tables --query "RouteTables[].RouteTableId" --filters Name=association.main,Values=false --output text`)
RT_ASSOCIATIE=(`aws ec2 describe-route-tables  --filters Name=association.main,Values=false --query "RouteTables[].Associations[].RouteTableAssociationId" --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 라우팅 테이블 리스트${txtrst}"
printf "%s\n" "${TOTAL_RT[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	
	for ROUTE_TABLE_INDEX in "${!TOTAL_RT[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${TOTAL_RT[${ROUTE_TABLE_INDEX}]}를 제거 중입니다.${txtrst}"
		aws ec2 disassociate-route-table --association-id ${RT_ASSOCIATIE[$ROUTE_TABLE_INDEX]}
		aws ec2 delete-route-table --route-table-id ${TOTAL_RT[${ROUTE_TABLE_INDEX}]}
	done
	

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	
