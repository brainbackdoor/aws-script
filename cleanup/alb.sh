#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


TOTAL_ALB=(`aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerName' --output text`)
TOTAL_ALB_ARN=(`aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn' --output text`)

TOTAL_TG=(`aws elbv2 describe-target-groups --query 'TargetGroups[].TargetGroupName' --output text`)
TOTAL_TG_ARN=(`aws elbv2 describe-target-groups --query 'TargetGroups[].TargetGroupArn' --output text`)

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 Load Balancer && Target Group 리스트${txtrst}"
echo -e "LB : ${TOTAL_ALB[@]}"
echo -e "TG : ${TOTAL_TG[@]}"

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then
	for ALB in "${TOTAL_ALB_ARN[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${ALB} 를 제거 중입니다.${txtrst}"
		aws elbv2 delete-load-balancer --load-balancer-arn ${ALB}
	done


	for TG in "${TOTAL_TG_ARN[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${TG} 를 제거 중입니다.${txtrst}"
		aws elbv2 delete-target-group --target-group-arn ${TG}
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


