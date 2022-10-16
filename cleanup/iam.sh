#!/bin/bash


## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray



if [[ $# -ne 1 ]]
then
    echo -e "${txtylw}=======================================${txtrst}"
    echo -e "${txtgrn}  << $0 🧐 >>${txtrst}"
    echo -e ""
    echo -e "❗사용자를 제거할 대상 IAM GROUP가 파라미터로 필요합니다."
    echo -e "${txtgrn} $0 ${txtred}{ infra-workshop }"
    echo -e "${txtylw}=======================================${txtrst}"
    exit
fi


TARGET_GROUP=$1
TOTAL_USERS=(`aws iam list-users --query "Users[].UserName" --output text`)
TARGET_USERS=()

for USER in "${TOTAL_USERS[@]}"; do

	GROUP=(`aws iam list-groups-for-user --user-name ${USER} --query 'Groups[].GroupName' --output text`)
	
	if [[ -n "${GROUP}" ]]; then
		if [ ${TARGET_GROUP} == ${GROUP} ]; then
			TARGET_USERS+=("${USER}")
		fi
	else
		echo "${USER} 는 제거 대상이 아닙니다."
	fi
done

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 사용자 리스트${txtrst}"
echo -e ${TARGET_USERS[@]} 

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then
	for USER in "${TARGET_USERS[@]}"; do
		echo -e ""
		echo -e "${txtred}>> ${USER} 사용자를 제거 중입니다.${txtrst}"
		echo -e "${txtgra}${USER} 사용자를 ${TARGET_GROUP}에서 분리합니다.${txtrst}"
		aws iam remove-user-from-group --group-name ${TARGET_GROUP} --user-name ${USER}

		echo -e "${txtgra}${USER} 사용자의 로그인 프로필을 제거합니다.${txtrst}"
		aws iam delete-login-profile --user-name ${USER}
		
		echo -e "${txtgra}${USER} 사용자의 정책을 모두 해제합니다.${txtrst}"
		POLICIES=(`aws iam list-attached-user-policies --user-name ${USER} --query 'AttachedPolicies[].PolicyArn' --output text`)
		for POLICY in "${POLICIES[@]}"; do
			aws iam detach-user-policy --user-name ${USER} --policy-arn ${POLICY}
		done

		echo -e "${txtrst}${USER} 사용자를 제거합니다."
		aws iam delete-user --user-name ${USER}
	done

	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}사용자를 모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "사용자를 제거하지 않았습니다."
fi	


