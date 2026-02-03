#!/bin/bash


SG_ID="sg-0f662185634b5ed2a"

AMI_ID="ami-0532be01f26a3de55"

for instance in $@
do 
   instance_id = $( aws ec2 run-instances 
   --image-id $AMI_ID\
   --instance-type "t3.micro" \
   --security-group-ids $SG_ID \
   --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
   --query 'Instance[0].InstanceId' \
   --output text )
   if [ $instance == "frontend" ]; then 
      IP=$(
         aws ec2 describe-instances \
          --instance-ids $instance_id \
          --query 'Reservations[].Instances[].PublicIpAddress' \
          --output text
      ) 
 else
    IP=$(
         aws ec2 describe-instances \
          --instance-ids $instance_id \
          --query 'Reservations[].Instances[].PrivateIpAddress' \
          --output text
    )
   fi 
done
