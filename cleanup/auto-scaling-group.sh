#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray



TOTAL_ASG=(`aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].AutoScalingGroupName' --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 ASG 리스트${txtrst}"
echo -e ${TOTAL_ASG[@]} 

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then
	for ASG in "${TOTAL_ASG[@]}"; do 
		echo -e ""
		echo -e "${txtgra}${ASG} 의 인스턴스를 제거합니다.${txtrst}"
		aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${ASG} --desired-capacity 0 --min-size 0 --max-size 0
	done
	while [[ -n `aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[].AutoScalingGroupName" --output text | grep ${ASG}` ]]; do
		echo -e "${txtgra}인스턴스를 제거 중입니다...${txtrst}"
		sleep 5
			
	done
	for ASG in "${TOTAL_ASG[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${ASG} 를 제거 중입니다.${txtrst}"
		aws autoscaling delete-auto-scaling-group --auto-scaling-group-name ${ASG}
	done
	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


