#! /bin/bash

# ======= Change these values [REQUIRED] ======= #
: ${KeyName:=my-north-virginia-key}    # Private key name for EC2 instances
: ${SAPInstallMediaBucket:=my-sap-install-files} # Bucket where SAP Install media is stored
: ${SAPInstallMediaFolder=nw-ase-dev-edition} # Bucket where SAP Install media is stored

# ======= Change these values [OPTIONAL] ======= #
: ${VpcCIDR:=10.0.0.0/16}               # CIDR for the existing VPC
: ${SAPSubnetCIDR:=10.0.4.0/24}         # CIDR for a Subnet in existing VPC where SAP system will be installed
: ${BastionCIDR:=10.0.0.0/16}           # CIDR for a VPC or Subnect which has your Bastion host
: ${STACKNAME:=sapapidemo}
: ${Environment:=sapdemo}                  # Added to artifact names created this template
: ${SAPInstanceType:=r4.large}             # Instance type you want for the SAP EC2 instance
: ${SAPMasterPwd:=welcome1}                # SAP Master Password
: ${OA2ClientPassword:=welcome1}           # Password used by SAP System user for OAuth token gen

# ======= Donot Change anything below this line ======= #
# All attributes
SAPSubnetCIDR=$SAPSubnetCIDR
BASTIONCIDR=$BastionCIDR
SAPDomainName=dummy.nodomain
SAPHostName=vhcalnplci
SAPEBSVolumeSize=200
InstallSAP=true
SAPInstallationTimeOut=14000

TEMPLATE=./SAPABAPDeveloperEditionWithVPC.yaml

aws cloudformation deploy \
--template-file $TEMPLATE \
--stack-name $STACKNAME \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides \
Environment=$Environment  \
VpcCIDR=$VpcCIDR \
SAPSubnetCIDR=$SAPSubnetCIDR \
BASTIONCIDR=$BASTIONCIDR \
SAPInstanceType=$SAPInstanceType \
KeyName=$KeyName \
SAPDomainName=$SAPDomainName \
SAPHostName=$SAPHostName \
SAPEBSVolumeSize=$SAPEBSVolumeSize \
SAPInstallMediaBucket=$SAPInstallMediaBucket \
SAPInstallMediaFolder=$SAPInstallMediaFolder \
SAPMasterPwd=$SAPMasterPwd \
SAPInstallationTimeOut=$SAPInstallationTimeOut 
