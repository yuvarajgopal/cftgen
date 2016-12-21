#!/bin/bash
resize2fs /dev/xvde1
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
export HOME=/root
BUCKET='{Ref:PublicBucketName}'
AWSREGION='{ Ref: AWS::Region }'
AWSSTACK='{   Ref   :    AWS::StackId   }'
HOSTNAME='_cfnHostname'
cd /usr/local/bin
wget http://${BUCKET}.s3.amazonaws.com/public/configuresysnetwork.sh
/bin/bash configuresysnetwork.sh ${HOSTNAME} east.{Ref:EnvironmentVar}.cloud.synchronoss.net
wget http://{$BUCKET}.s3.amazonaws.com/public/opt-mount.sh
chmod a+rx opt-mount.sh
bash ./opt-mount.sh
wget http://${BUCKET}.s3.amazonaws.com/public/install-aws-tools.sh
bash ./install-aws-tools.sh
cd /root
mkdir -p /root/.aws
/usr/bin/cfn-init -s $AWSSTACK -r _cfnConfig -c envDec --region $AWSREGION
cd /usr/local/bin
wget http://${BUCKET}.s3.amazonaws.com/public/install-chef-client.sh
/bin/bash /usr/local/bin/install-chef-client.sh
cd /root
pip install requests==1.1.0
/usr/bin/cfn-init -s $AWSSTACK -r _cfnConfig -c provision --region $AWSREGION
wget http://${BUCKET}.s3.amazonaws.com/public/client-instance-switch.sh -O - | /bin/bash
echo "Running chef-client"
chef-client -j /etc/chef/roles.json >/tmp/chef-client-1.log 2>&1 || chef-client -j /etc/chef/roles.json >/tmp/chef-client-2.log 2>&1
STATUS=$?
echo "chef-client exit status $STATUS"
/usr/bin/cfn-signal -e $? '{Ref:WaitHandleAppProd}'
