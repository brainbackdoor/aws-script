#!/bin/bash

## 변수 설정

txtrst='\033[1;37m' # White
txtred='\033[1;31m' # Red
txtylw='\033[1;33m' # Yellow
txtpur='\033[1;35m' # Purple
txtgrn='\033[1;32m' # Green
txtgra='\033[1;30m' # Gray


EXCLUDED_KEY_PAIRS=("brainbackdoor.pem")
TOTAL_KEY_PAIR=(`aws ec2 describe-key-pairs --query "KeyPairs[].KeyName" --output text`)

for EXCLUDED_KEY_PAIR in "${EXCLUDED_KEY_PAIRS[@]}"; do
	TOTAL_KEY_PAIR=(${TOTAL_KEY_PAIR[@]/$EXCLUDED_KEY_PAIR})
done

echo -e ""	
echo -e ""	
echo -e "${txtred}🎯 제거할 키 페어 리스트${txtrst}"
printf "%s\n"  ${TOTAL_KEY_PAIR[@]} 

echo -e ""	
echo -e "${txtylw}제거하시겠습니까? [ Y ]${txtrst}"

read Yes

if [ $Yes == "Y" ];then

	for KEY in "${TOTAL_KEY_PAIR[@]}"; do 
		echo -e ""
		echo -e "${txtred}>> ${KEY} 를 제거 중입니다.${txtrst}"
		aws ec2 delete-key-pair --key-name ${KEY}
	done
	echo -e ""
	echo -e "${txtylw}=======================================${txtrst}"
	echo -e "${txtgrn}모두 제거했습니다.${txtrst}"
	echo -e "${txtylw}=======================================${txtrst}"

else 
	echo -e ""
	echo -e "제거하지 않았습니다."
fi	


