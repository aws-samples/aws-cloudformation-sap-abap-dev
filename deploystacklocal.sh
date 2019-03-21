#! /bin/bash
source awsccsetcred.sh kk1
Environment=sapdemo20 STACKNAME=sapdemo20 VPCID=vpc-0302428ff21e952f6 SAPSubnet=subnet-0ce17d5fe009bc864 KeyName=kk1-north-virginia-key SAPInstallMediaBucket=kk-sap-install-files SAPInstallMediaFolder=nw-ase-dev-edition \
     ./deploystack.sh