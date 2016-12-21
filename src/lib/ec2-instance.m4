dnl -*- indent-tabs-mode: nil -*-
divert(-1)


define(`KEYNAME',`"KeyName" : cfnArg(`$1')')dnl
define(`PRIVATEIP',`"PrivateIpAddress" : cfnArg(`$1')')dnl
define(`SUBNETID',`"SubnetId" : cfnArg(`$1')')dnl
define(`SG',`cfnArg(`$1')')dnl
dnl
define(`SECURITYGROUPIDS',`"SecurityGroupIds" : [ dnl
join(`, ',$@) ]')dnl
dnl
define(`DISKS',`"BlockDeviceMappings" : [
join(`,
',$@) ]')dnl
dnl
define(`EBSDEVICE',`{ "DeviceName": cfnArg(`$1')`,' "Ebs" : { "VolumeSize" : cfnArg(`$2') } }')dnl
define(`SSDDEVICE',
        `{ "DeviceName": cfnArg(`$1')`,' "Ebs" : { "VolumeSize" : cfnArg(`$2'), "VolumeType" : "gp2" } }')dnl
define(`NODEVICE',`{ "DeviceName": cfnArg(`$1')`,' "NoDevice" : {} }')dnl
#
# define an ephemeral disk
#   EPHDISK("/dev/sdb", 0)
#
define(`EPHDEVICE',
	`{ "DeviceName": cfnArg(`$1')`,' "VirtualName": "ephemeral$2" }')dnl
dnl
dnl INSTANCE(name, type, chefRole [, prop ..])
dnl ami gets looked up based on the imagetype via the maps
dnl
define(`INSTANCE',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::Instance'),
  "Properties" : {
    "InstanceType" : cfnArg(`$2'),
    "ImageId" : cfnFindInMap("AWSRegionArch2AMI",
                              cfnRef(AWS::Region),
                              `cfnFindInMap("AWSInstanceType2Arch",
                                             cfnArg(`$2'), "Arch")'),
    join(`,
    ',
        shift(shift(shift($@)))),
    "UserData" : cfnMakeInstallSh(`../common/install.sh.jl',`$1')
  }
#  ,
#  ciMetaData(`base,$3')
}')dnl


# the following macros will guarantee a consistent layout
# for the swap and /opt disk devices
#

# ROOTDISK|ROOTSSD([size[, device])
#
define(`ROOTDISK',`EBSDEVICE(ifelse(`$2',`',"ROOTDEV", cfnArg(`$2')), dnl
                   ifelse(`$1',`',`15',`cfnArg($1)'))')dnl
define(`ROOTSSD',`SSDDEVICE(ifelse(`$2',`',"ROOTDEV", cfnArg(`$2')), dnl
                   ifelse(`$1',`',`15',`cfnArg($1)'))')dnl
# SWAPDISK() always mounts the first (0th) ephemeral
define(`SWAPDISK',`EPHDEVICE("SWAPDEV",0)')dnl

# OPTDISK(size)
define(`OPTDISK',`EBSDEVICE(ifelse(`$2', `', "OPTDEV", cfnArg(`$2')),
                cfnArg(`$1'))')dnl


# mkPlacementGroup(name[,strategy])

define(`mkPlacementGroup', `"$1" : {
  _RESOURCETYPE(`AWS::EC2::PlacementGroup'),
  "Properties": {
    "Strategy": ifelse(`$2', `', `"cluster"', `cfnArg($2)')
   }
}')

divert`'dnl
