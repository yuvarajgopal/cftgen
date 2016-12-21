dnl -*- indent-tabs-mode: nil -*-
divert(-1)
dnl
dnl regexParameter(name,descr,[default],pattern,constraint)
dnl
define(`regexParameter',`"$1" : {
  "Description" : "$2",
  "Type" : "String",
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "AllowedPattern" : "$4",
  "ConstraintDescription" : "$5"
}')dnl
dnl
dnl regexParameterLen(name,descr,[default],pattern,constraint,min,max)
dnl
define(`regexParameterLen',`"$1" : {
  "Description" : "$2",
  "Type" : "String",
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "MinLength" : "$6",  "MaxLength" : "$7",
  "AllowedPattern" : "$4",
  "ConstraintDescription" : "$5"
}')dnl

dnl
dnl paramAZ(name, descr [,default])
dnl

define(`paramAZ',
	`regexParameter($1,
                        `ifelse(`$2', `', `Availability Zone', `$2')',
                        $3,`[a-z]*-[a-z]*-[1-9][a-z]', `must be a valid AZ')')

define(`paramARN',
        `regexParameter($1,
                        `ifelse(`$2', `', `ARN', `$2')',
                        $3,`arn:aws:.*',`a valid ARN')')

dnl
dnl paramChefEnv(name,descr)
dnl

define(`paramChefEnv',
        `regexParameter($1,
                        `ifelse(`$2', `', `Chef Environment Name', `$2')',
                        $3,
                        `[-a-zA-Z0-9]{1,}',`an existing environment name')')

dnl
dnl param{Username|Password}(name,descr[,default])
dnl

define(`paramUsername',
        `regexParameter($1,
                        `ifelse(`$2', `', `username', `$2')',
                        $3,
                        `[-a-zA-Z0-9.]{1,}',`valid user name')')

define(`paramPassword',
        `regexParameter($1,
                        `ifelse(`$2', `', `password', `$2')',
                        $3,
                        `[-a-zA-Z0-9.!*,/@#$&+_=]{1,}',`valid password')')

# Params for the AWS resurce types
#    paramXXXX(name, descr[, default])
# Ami
# Igw
# Vgw
# Vpc
# VpcPeer
# Subnet
# NetworkAcl
# RouteTable
# SecurityGroup
# EipAllocId


define(`paramAmi',
	`regexParameter($1,
                        `ifelse(`$2', `', `Machine Image', `$2')',
                        `ifelse(`$3',`',`ami-00000000',`$3')',
                        `ami-[0-9a-f]{8}',
                        `a valid aws image id')')

define(`paramIgw',
        `regexParameter($1,
                        `ifelse(`$2', `', `Internet Gateway ID', `$2')',
                        `ifelse(`$3',`',`igw-00000000',`$3')',
                        `igw-[0-9a-f]{8}',`a valid aws vgw id')')

define(`paramVgw',
        `regexParameter($1,
                        `ifelse(`$2', `', `Virtual Private Gateway ID', `$2')',
                        `ifelse(`$3',`',`vgw-00000000',`$3')',
                        `vgw-[0-9a-f]{8}',`a valid aws vgw id')')

define(`paramVpc',
        `regexParameter($1,
                        `ifelse(`$2', `', `Virtual Private Cloud ID', `$2')',
                        `ifelse(`$3',`',`vpc-00000000',`$3')',
                        `vpc-[0-9a-f]{8}',`a valid aws vpc id')')dnl
define(`paramVpcPeer',
        `regexParameter($1,
                `ifelse(`$2',`', `Vpc Peer Id', `$2')',
                `ifelse(`$3',`', `none',`$3')',
                `none|pcx-[0-9a-f]{8}',
                `a valid aws vpc peer designator')')

define(`paramSubnet',
        `regexParameter($1,
                        `ifelse(`$2',`', `Subnet Id', `$2')',
                        `ifelse(`$3',`',`subnet-00000000',`$3')',
                        `subnet-[0-9a-f]{8}',`a valid aws subnet id')')

define(`paramNetworkAcl',
        `regexParameter($1,
                        `ifelse(`$2', `', `Network ACL ID', `$2')',
                        `ifelse(`$3',`',`acl-00000000',`$3')',
                        `acl-[0-9a-f]{8}',`a valid aws acl id')')

define(`paramRouteTable',
        `regexParameter($1,
                        `ifelse(`$2', `', `Route Table ID', `$2')',
                        `ifelse(`$3',`',`rtb-00000000',`$3')',
                        `rtb-[0-9a-f]{8}',`a valid aws route table id')')

define(`paramSecurityGroup',
        `regexParameter($1,
                        `ifelse(`$2', `', `Security Group ID', `$2')',
                        `ifelse(`$3', `', `sg-00000000', `$3')',
                        `sg-[0-9a-f]{8}', `a valid aws security group id')')

define(`paramEipAllocId',
        `regexParameter($1,
                `ifelse(`$2',`', `EIP Allocation ID', `$2')',
                `ifelse(`$3',`', `none',`$3')',
                `none|eipalloc-[0-9a-f]{8}',
                `a valid eip allocation id')')

#
# paramCname
#  -- a valid name for a Route53 CNAME record

define(`paramCname',
        `regexParameter($1,
                        `ifelse(`$2', `', `Route53 CNAME', `$2')',
                        `ifelse(`$3',`',`none',`$3')',
                        `none|[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]',
                        `a DNS CNAME')'
)


#
# paramIpAddress
#  -- not perfect....

define(`paramIpAddress',
        `regexParameter($1,
                        `ifelse(`$2', `', `IPv4 Address', `$2')',
                        `ifelse(`$3',`',`none',`$3')',
                        `none|([0-9]{1,3}\\.){3}[0-9]{1,3}',`an ipv4 address')')

#
# paramEmailAddr(name, [descr][, default])

define(`paramEmailAddr',
        `regexParameter($1,
                        `ifelse(`$2', `', `Email Address', `$2')',
                        $3,
                        `[a-zA-Z][-a-zA-Z0-9._%+]*@[-A-Za-z0-9.]+\\.[A-Za-z]{2,4}',
                        `an email address')')

define(`paramDomain',
        `regexParameter($1,
                        `ifelse(`$2', `', `DNS Domain Name', `$2')',
                        $3,
                        `[-A-Za-z0-9.]+\\.[A-Za-z]{2,4}',
                        `a domain')')dnl
dnl
dnl
define(`paramS3Bucket',
        `regexParameter($1,
                        `ifelse(`$2', `', `S3 Bucket Name', `$2')',
                        $3,
                        `[-A-Za-z0-9.]{2,64}',
                        `a S3 bucket name')')
dnl
dnl paramInstanceType(name,descr,default)
dnl

define(`paramInstanceType',`"$1" : {
  "Description" : "ifelse(`$2', `', `AWS EC2 Instance Type', `$2')",
  "Type" : "String",
ifelse(`$3',`',`dnl',`  "Default" : $3,')
  "AllowedValues" : [
     "t1.micro",
     "t2.micro", "t2.small", "t2.medium", "t2.large",
     "m1.small", "m1.medium", "m1.large", "m1.xlarge",
     "m2.xlarge", "m2.2xlarge", "m2.4xlarge",
     "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge",
     "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge",
     "c1.medium", "c1.xlarge",
     "c3.large", "c3.xlarge", "c3.2xlarge", "c3.4xlarge", "c3.8xlarge",
     "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge",
     "cc1.4xlarge",
     "cc2.8xlarge",
     "cg1.4xlarge",
     "cr1.8xlarge",
     "d2.xlarge", "d2.2xlarge", "d2.4xlarge", "d2.8xlarge",
     "g2.2xlarge", "g2.8xlarge",
     "hi1.4xlarge",
     "hs1.8xlarge",
     "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge",
     "r3.large", "r3.xlarge", "r3.2xlarge", "r3.4xlarge", "r3.8xlarge"
  ],
  "ConstraintDescription" : "a valid EC2 instance type."
}')

define(`paramDbName',
        `regexParameter($1,
                        `ifelse(`$2', `', `Database Name', `$2')',
                        $3,
                        `[a-zA-Z][a-zA-Z0-9_]*',`a valid RDS database name')')



dnl
dnl paramDbInstanceType(name,descr,default)
dnl

define(`paramDbInstanceType',`"$1" : {
  "Description" : "ifelse(`$2', `', `AWS RDS Instance Type', `$2')",
  "Type" : "String",
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "AllowedValues" : [
     "db.t1.micro", "db.m1.small", "db.m1.medium", "db.m1.large", "db.m1.xlarge",
     "db.m2.xlarge", "db.m2.2xlarge", "db.m2.4xlarge",
     "db.m3.medium", "db.m3.large", "db.m3.xlarge", "db.m3.2xlarge",
     "db.cr1.8xlarge",
     "db.r3.large", "db.r3.xlarge", "db.r3.2xlarge", "db.r3.4xlarge", "db.r3.8xlarge"
  ],
  "ConstraintDescription" : "a valid DB instance type."
}')

dnl
dnl paramDiskSize(name,descr[,default])
dnl

define(`paramRdsDiskSize',`"$1" : {
  "Description" : "ifelse(`$2', `', `RDS disk Size (gb)', `$2')",
  "Default" : ifelse(`$3',`',`"0"', `"$3"'),
  "Type" : "Number",  "MinValue" : "0",  "MaxValue" : "3072"
}')dnl
dnl
dnl
define(`paramCidrBlock',
       `regexParameterLen($1,$2,$3,
            `(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})',
            `a valid CIDR specification',9,18)')dnl
dnl
dnl
define(`paramKey',
       `regexParameterLen($1,$2,$3,
            `[-_ a-zA-Z0-9]*',
            `a valid key',
	    1,64)')dnl
dnl
dnl paramURL(name,descr[,default])
dnl
define(`paramURL',
       `regexParameterLen($1,$2,$3,
       `[a-z][a-z0-9]*://[-a-z0-9.]*(:[0-9]{1,5})?',
       `a valid URL',
       10,128)')dnl
dnl
dnl
dnl paramPort(name,descr[,default])
dnl
define(`paramPort',`"$1" : {
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "Description" : "$2",
  "Type" : "Number",  "MinValue" : "1",  "MaxValue" : "65535"
}')

#
# paramDiskSize(name, descr[, default][, min][, max])


define(`paramDiskSize',`"$1" : {
  "Description" : "ifelse(`$2', `', `Disk Size (gb)', `$2')",
  "Default" : ifelse(`$3',`',`"0"', `"$3"'),
  "Type" : "Number",
  "MinValue" : ifelse(`$4', `', `"0"', `"$4"'),
  "MaxValue" : ifelse(`$5', `', `"2000"', `"$5"')
}')

dnl
dnl paramAccessKey(name,descr[,default])
dnl

define(`paramAccessKey',`"$1" : {
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "Description" : "ifelse(`$2', `', `Access Key', `$2')",
  "Type" : "String",
  "MinLength" : "20",
  "MaxLength" : "20"
}')

dnl
dnl paramSecretKey(name,descr[,default])
dnl

define(`paramSecretKey',`"$1" : {
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "Description" : "ifelse(`$2', `', `Secret Key', `$2')",
  "Type" : "String",
  "MinLength" : "40",
  "MaxLength" : "40"
}')

dnl
dnl paramInteger(name,descr[,default[,min[,max]]])
dnl

define(`paramInteger',`"$1" : {
ifelse(`$3',`',`dnl',`  "Default" : $3,')
  "Description" : "$2",
  "Type" : "Number",
  "MinValue" : ifelse(`$4', `', `"1"', `$4'),
  "MaxValue" : ifelse(`$5', `', `"65535"', `$5')
}')

#
# paramString(name, descr, default, regex, minlen, maxlen)
#
# only the name is required
#

define(`paramString',`"$1" : {
  "Type" : "String",
ifelse(`$3', `', `dnl', `  "Default" : "$3",')
ifelse(`$4', `', `dnl', `  "AllowedPattern": "$4",')
ifelse(`$5', `', `dnl', `  "MinLength": "$5",')
ifelse(`$6', `', `dnl', `  "MaxLength": "$6",')
  "Description" : ifelse(`$2', `', `"string"', "$2")
}')



#
#  OneOf(name, descr, (choice, ...)[, default])
#
define(`paramOneOf', `"$1" : {
  "Type" : "String",
ifelse(`$4',`',`dnl',`  "Default" : "$4",')
  "Description" : "$2",
  "AllowedValues" : json_listify($3)
}')


#
# a boolean type
# allows True or False
#
# paramBool(name, descr [, default])

define(`paramBoolean', `"$1" : {
  "Description" : "$2",
  "Type" : "String",
ifelse(`$3',`',`dnl',`  "Default" : "$3",')
  "AllowedValues" : [ "False", "True" ]
}')

#
# paramVpnGatewayType(name, descr, [, default])
#

define(`paramVpnGatewayType', `"$1" : {
  "Description" : "ifelse(`$2', `', `VPN Gateway ID', `$2')",
  "Type" : "String",
  "Default" : ifelse(`$3', `', `"none"', `"$3"'),
  "AllowedValues" : [ "none", "ipsec.1"]
}')

#
# paramCustomerGatewayType(name, descr, [, default])
#

define(`paramCustomerGatewayType', `"$1" : {
  "Description" : "ifelse(`$2', `', `Customer Gateway ID', `$2')",
  "Type" : "String",
  "Default" : ifelse(`$3', `', `"none"', `"$3"'),
  "AllowedValues" : [ "none", "ipsec.1"]
}')

#
# paramBootPriority(number)
#
#  defines a boot priority level
#  and sets up the tag macros to include it if it was specified

define(`paramBootPriority', `"BootPriority" : {
  "Description" : "ifelse(`$2', `', `Boot Priority Level', `$2')",
  "Type" : "Number",
  "Default" : ifelse(`$1', `', `"0"', `"$1"'),
  "MinValue" : "0"
define(`_PARAM_BOOT_PRIORITY',`$1')
}')


#
# paramPurpose(number)
#
#  defines a purpose for the instance being built
#  and sets up the tag macros to include it if it was specified

define(`paramPurpose', `"Purpose" : {
  "Description" : "ifelse(`$2', `', `Instance Purpose', `$2')",
  "Type" : "String",
  "Default" : ifelse(`$1', `', `"component"', `"$1"'),
  "AllowedPattern" : "[A-Za-z0-9_-]+"
define(`_PARAM_PURPOSE', `$1')
}')


#
# paramAttachedVolume(name,size,type,device,mountpoint,iops)
#
#  size in GB
#  type is stndard, gp2, or io1
#  device is /dev/....
#  mountpoint should look like a dirctory, or maybe "None"
#  iops should be the requested number of provisioned iops for the io1 type
#

define(`paramAttachedVolume',`"$1" : {
  "Type" : "CommaDelimitedList",
  # find the parameters or set defaults
  define(`_size', `ifelse(`$2', `', `0', `$2')')
  define(`_type', `ifelse(`$3', `', `standard', `$3')')
  define(`_device', `ifelse(`$4', `', `none', `$4')')
  define(`_mountpoint', `ifelse(`$5', `', `none', `$5')')
  define(`_iops', `ifelse(`$6', `', `0', `$6')')

  "Default" : "_size, _type, _device, _mountpoint, _iops",
  "Description" : "Attached Volume Info"

  undefine(`_size', `_type', `_device', `_mountpoint', `_iops')
}')

#
# paramPlacementGroup(name, descr, default)
#

define(`paramPlacementGroup', `"$1" : {
  "Type": "String",
  "Description" : ifelse(`$2', `', `"EC2 Placement group for instances in $1"', "$2"),
  "Default" : ifelse(`$3', `', `"none"', `"$3"')
}')

#
# paramPlacementStrategy(name[, description [, strategy])
#
# as of now, cluster is the only allowed strategy
#

define(`paramPlacementStrategy', `"$1" : {
  "Type": "String",
  "Description": ifelse(`$2', `', `"Placement Strategy"',`$2'),
  "Default": ifelse(`$3', `', `"cluster"', `"$3"'),
  "AllowedValues": [ "cluster" ]
}')

#
# paramTenancy(name[, [description][, [tenancy]]])
#  --specify dedicated or none (default)
#

define(`paramTenancy', `"$1" : {
  "Type": "String",
  "Description": ifelse(`$2', `', `"Tenancy for EC2 Instance"',`$2'),
  "Default": ifelse(`$3', `', `"none"', `"$3"'),
  "AllowedValues": [ "none", "dedicated" ]
}')

# ELB related params

define(`paramElbScheme', `paramOneOf(`$1', `type of ELB',
                         `( "internal", "internet-facing" )',
                         `internet-facing')')

#
# These are the special AWS types,

define(`paramInstances', `"$1" : {
  "Type": "List<AWS::EC2::Instance::Id>",
  "Description": ifelse(`$2', `', `"List of Valid Instance Ids"',`$2')
}')

define(`paramSubnets', `"$1" : {
  "Type": "List<AWS::EC2::Subnet::Id>",
  "Description": ifelse(`$2', `', `"List of Valid Subnet Ids"',`$2')
}')

define(`paramSecurityGroups', `"$1" : {
  "Type": "List<AWS::EC2::SecurityGroup::Id>",
  "Description": ifelse(`$2', `', `"List of Valid Security Group Ids"',`$2')
}')


divert`'dnl
