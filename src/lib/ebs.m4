divert(-1)             # -*- indent-tabs-mode: nil -*-

#
# mkEbsVolume(name, size, az)
#
define(`mkEbsVolume',`"$1": {
  _RESOURCETYPE(`AWS::EC2::Volume'),
  "Properties": {
    "Size": cfnArg(`$2'),
    "AvailabilityZone": cfnArg(`$3'),
    "VolumeType": "standard",
    "Tags": cfnTagList("$1")
   }
}
')dnl

#
# mkIopsVolume(name, size, az, iops)
#
define(`mkIopsVolume',`"$1": {
  _RESOURCETYPE(`AWS::EC2::Volume'),
  "Properties": {
    "Size": cfnArg(`$2'),
    "AvailabilityZone": cfnArg(`$3'),
    "Iops": cfnArg(`$4'),
    "VolumeType": "io1",
    "Tags": cfnTagList("$1")
   }
}
')dnl

#
# attVolume(name, volume, instance, device)
#
define(`attVolume',`"$1": {
     _RESOURCETYPE(`AWS::EC2::VolumeAttachment'),
     "DependsOn" : [ $3, $4 ],
     "Properties" : {
        "VolumeId" : cfnArg(`$2'),
        "InstanceId" : cfnArg(`$3'),
        "Device" : cfnArg(`$4')
     }
   }')dnl

#
# mountVolume(name, volume, instance, device)
# this is just attVolume, but the volume and instance
# are NOT sepcified as refs (&x)
#
define(`mountVolume',`"$1": {
     _RESOURCETYPE(`AWS::EC2::VolumeAttachment'),
#     "DependsOn" : [ "$3" ],
     "Properties" : {
        "VolumeId" : cfnArg(&`$2'),
        "InstanceId" : cfnArg(&`$3'),
        "Device" : cfnArg(`$4')
     }
   }')


divert`'dnl
