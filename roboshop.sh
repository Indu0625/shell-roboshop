#!/bin/bash
AMI_ID="09c813fb71547fc4f"
SG_ID="0f8421f2f12b0f03f"

for instance in $@
do
   INSTANCE_ID= $(aws ec2 run-instances --image-id  ami-09c813fb71547fc4f --instance-type t3.micro  --security-group-ids  sg-0f8421f2f12b0f03f --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"  --query 'Instances[0].InstanceId' --output text)

    # Get Private IP
    if [ $instance != "frontend" ]; then
    IP=$(aws ec2 run-instances --image-id  ami-09c813fb71547fc4f --instance-type t3.micro  --security-group-ids  sg-0f8421f2f12b0f03f --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"  --query 'Instances[0].PrivateIPAddress' --output text)
    else
    IP=$(aws ec2 run-instances --image-id  ami-09c813fb71547fc4f --instance-type t3.micro  --security-group-ids  sg-0f8421f2f12b0f03f --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"  --query 'Instances[0].PublicIPAddress' --output text)
    fi
    echo "$instance: $IP"
    done