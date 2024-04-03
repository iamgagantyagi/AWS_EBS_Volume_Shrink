#!/bin/bash
#set -x
PWD="${HOME}/volume_shrink"

missing_vars () {
  echo;
  echo "Please supply a proper actions";
  echo;
  echo "Usage: ./volume_shrink.sh [aws_use1_prod|aws_use1_qa|aws_usw2_qa|aws_usw2_prod] [volume-shrink] ";
  echo;
  echo "Example: ./volume_shrink.sh aws_usw2_qa volume-shrink ";
  echo;
  exit 1;
}

if [ -z "${1}" ] || [ -z "${2}" ]; then
  missing_vars;
fi

case $1 in
  aws_use1_prod )  
    REGION="us-east-1";
    HOSTS="aws_use1_prod";
    ;;
  aws_use1_qa )
    REGION="us-east-1";
    HOSTS="aws_use1_qa";
    ;;
  aws_usw2_prod )
    REGION="us-west-2";
    HOSTS="aws_usw2_prod";
    ;;
  aws_usw2_qa )
    REGION="us-west-2";
    HOSTS="aws_usw2_qa";
    ;;
  * )
    missing_vars;
    ;;
esac

case $2 in
  volume-shrink )
    sed -i "s/hosts: .*/hosts: ${HOSTS}/g" ${PWD}/volume-shrink.yaml
    sed -i "s/REGION: .*/REGION: ${REGION}/g" ${PWD}/volume-shrink.yaml
    ansible-playbook -i ${PWD}/hosts.ini --vault-password-file=${PWD}/vault_password.txt ${PWD}/volume-shrink.yaml -vvvv
    ;;
  * )
    missing_vars;
    ;;
esac
