#!/bin/bash
set -euo pipefail

#Checking and installing the aws cli if not found
if ! command -v aws &> /dev/null/; then
	echo "AWS not found , installing.."
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    	sudo apt install unzip -y
    	unzip awscliv2.zip
    	sudo ./aws/install 
fi

#Updating the AWS CLI to make sure it is current
sudo apt update -y

#Creating the timestamp for the backup file
FILE="backup-$(date +%Y-%m-%d-%H%M).sql"

#Running the mysqldump inside the Mysql container and saving it 
docker exec wordpress-pro-db-1 mysqldump -u root -padminmypassword123 wordpress_db > $FILE

#Uploading the backup file to S3
aws s3 cp $FILE s3://wordpress-backup-rave-2026/

#Print a confirmation message
echo "Backup successful, file is uploaded to s3://wordpress-backup-rave-2026/$FILE"
