# AWS CloudFormation template for installing SAP ABAP Developer Edition

This repository contains a sample CloudFormation template (yaml) to install [SAP ABAP Developer Edition system](https://www.sap.com/developer/trials-downloads/additional-downloads/sap-netweaver-as-abap-developer-edition-sp02-7-51-14493.html). There are two templates - one for instsalling SAP ABAP developer edition in an existing VPC and the other in a new VPC. Following AWS resources are created as a part of this CloudFormation template

- An EC2 instance for installing the SAP ABAP Developer Edition
- An EC2 IAM role for the EC2 instance to have access to install media files stored in an S3 bucket
- Required security groups to open up ports 8000, 44300, 22 and 3200 in the EC2 instance for instances within the VPC
- Required Network interfaces for the EC2 instance

If you choose to install SAP ABAP developer edition in a new VPC, following resources are also created

- A new VPC
- A public subnet within the newly created VPC
- A private subnet within the newly created VPC
- An Internet Gateway attached to the public subnet
- A NAT gateway for the private subnet
- Required route tables

Note: The repository doesn't contain the SAP ABAP Developer Edition media files. You will have to download it and upload to an S3 bucket of your choice before using this template

# Getting Started

### Prerequisites
- Download SAP ABAP Developer Edition from [here](https://www.sap.com/developer/trials-downloads/additional-downloads/sap-netweaver-as-abap-developer-edition-sp02-7-51-14493.html). If you have issues with this link, you can also download the media file from the 'Trials and Downloads' main site [here](https://developers.sap.com/trials-downloads.html). Search for "ABAP Developer Edition ASE" and choose the latest edition available for download. 
- Once downloaded, upload all downloaded files to an S3 bucket of choice. It is required that the S3 bucket is created in the same region where you intend to run this CloudFormation template
- [AWS CLI already configured with Administrator permission](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)

### Installing

- Clone this repository into a folder of choice.

- Navigate to the folder for this repo
```bash
cd aws-cloudformation-sap-abap-dev
```

- In case of deploying SAP ABAP Developer edition to an existing VPC, edit file deploystackwithoutVPC.sh with the required variable values as per your setup [Lines 4 to 11]. Then execute the script
```bash
./deploystackwithoutVPC.sh
```

- In case of deploying SAP ABAP Developer edition in a new VPC, edit file deploystackwithVPC.sh with the required variable values as per your setup [Lines 4 to 6]. Then execute the script
```bash
./deploystackwithVPC.sh
```

It takes about an hour to finish the installation. Once the stack creation is complete, you should be able to access the installed SAP application using your SAPGUI. Since this installs the SAP application in a private subnet, you will need to use a Windows bastion host to access the application. This cloud formation template doesn't create a bastion host. You can either create one yourself or you can use an existing Bastion host in a different VPC. You will have to enable VPC peering and adjust the security groups and route tables accordingly in that case.

### Troubleshooting
If you are not able to connect, make sure SAP was installed successfully. Connect to the EC2 instance using SSH and view the 'install_log.txt' file in the home directory (/home/ec2-user). If you see a message that 'install.sh' file is not found, most probably the install media files weren't copied over from your bucket. go to directory /home/ec2-user/installfiles and see if all the 10 installation files were copied over. If you don't see any media files in that directory (or only see some of them downloaded), validate if you are able to access the install media bucket and folder using command line. At this point, you have two options, you can either manually install SAP system using the scripts available under 'UserData' section in SAPABAPDeveloperEditionwithVPC.yaml or delete the cloud formation stack and recreate it after having fixed any S3 bucket issues.

If you choose to install SAP manually at this point, follow the steps below
- From cloud formation stack, get the bucket name where install files are stored (parameter SAPInstallMediaBucket). For e.g. 123456789-us-east-1-aws-sap-demo-install-files
- From cloud formation stack, get the install media folder name (parameter SAPInstallMediaFolder ). For e.g. nw-ase-dev-edition/
- From cloud formation stack get the master password to use for the SAP Database (parameter SAPMasterPwd). For e.g. pass1234
- SSH in to the EC2 instance and execute the following commands (make sure to replace the SAP Install Media bucket and Install media folder names accordingly)
```
cd /home/ec2-user/
rm -rf installfiles
mkdir installfiles
cd installfiles
sudo su
aws s3 cp s3://123456789-us-east-1-aws-sap-demo-install-files/nw-ase-dev-edition/ . --recursive
service uuidd start
unrar x sap_netweaver_as_abap_751_sp02_ase_dev_edition_part01.rar
chmod 755 install.sh
echo -e "\nyes\npass1234\npass1234\n" | sh install.sh &> /home/ec2-user/install_log.txt
```

This will take about ~60 mins to run. If all goes well, you should be able to connect to the SAP system using SAPGUI

If SAP has been installed correctly but you are not able to access the system using SAPGUI, check the security groups attached to the EC2 instance to make sure the inbound rules are correct.

## License Summary
This sample code is made available under a modified MIT license. See the LICENSE file.