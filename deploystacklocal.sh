#! /bin/bash
source awsccsetcred.sh kk
KEYNAME=kk-north-virginia-key
ENVIRONMENT=sapabapdev
STACKNAME=sapabapdev
VPCID=vpc-0ef821e5de0eb08fd
SAPSUBNET=subnet-0122767ce0d5e8f50
SAPINSTALLMEDIABUCKET=kk-sap-install-files
SAPINSTALLMEDIAFOLDER=nw-ase-dev-edition
BastionCIDR=10.0.4.0/24

Environment=$ENVIRONMENT \
     STACKNAME=$STACKNAME \
     VPCID=$VPCID \
     SAPSubnet=$SAPSUBNET \
     KeyName=$KEYNAME \
     SAPInstallMediaBucket=$SAPINSTALLMEDIABUCKET \
     SAPInstallMediaFolder=$SAPINSTALLMEDIAFOLDER \
     BastionCIDR=$BastionCIDR \
     ./deploystack.sh