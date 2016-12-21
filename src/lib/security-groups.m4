divert(-1)		       # -*- indent-tabs-mode: nil -*-
#
#
# macros related to securty groups
#

#
# mkVpcSecurityGroup(name, vpc,descr)

define(`mkVpcSecurityGroup',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::SecurityGroup'),
  "Properties" : {
    "GroupDescription" : "$3",
    "VpcId" : cfnArg($2),
     "Tags" : cfnTagList("tagPrefix`'$1")
  }
}')

#
#
# cfnSecurityGroupAccessClause(proto,port,cidrblock)
#
define(`cfnSecurityGroupAccessClause',`{dnl
     "IpProtocol" : cfnArg(`$1'), "CidrIp" : cfnArg(`$3'),
define(`_port',`cfnArg($2)')dnl
ifelse(regexp(_port,`^"[-0-9][0-9]*"$'),0,
        `     "FromPort" : $2, "ToPort" : $2',
       regexp(`$2',`^"[0-9][0-9]*-[0-9][0-9]*"$'),0,
      `      regexp(`$2',`^"\([0-9]*\)-\([0-9]*\)"$',
                         `"FromPort" : "\1", "ToPort" : "\2"')',
      `"FromPort": _port, "ToPort": _port`'')dnl
undefine(`_port')}')dnl

#
# AddSecurityGroupRule(sg, id, dir, proto, "port", "cidrblock")
#
#   port can be a single port
#        or a range
#
define(`addSecurityGroupRule',`"$1r$2$3" : {
  _RESOURCETYPE(`AWS::EC2::SecurityGroup'ifelse($3,in,Ingress,Egress)),
  "Properties" : {
     "GroupId" : cfnRef($1),
     "IpProtocol" : $4, "CidrIp" : cfnArg(`$6'),
ifelse(regexp(`$5',`^"[-0-9][0-9]*"$'),0,
        `     "FromPort" : $5, "ToPort" : $5',
       regexp(`$5',`^"[0-9][0-9]*-[0-9][0-9]*"$'),0,
      `      regexp(`$5',`^"\([0-9]*\)-\([0-9]*\)"$',
                         `"FromPort" : "\1", "ToPort" : "\2"')',
      `      "FromPort" :  cfnArg(`$5'), "ToPort" : cfnArg(`$5')'
      )
  }
}')



#
# _sg_proto_and_port_properties(group, proto, portstart, portend)

define(`_sg_group_proto_and_port_properties',`
  "GroupId": cfnArg(`$1'),
  "IpProtocol": cfnArg(`$2'),
  ifelse(
    `$3', `"all"',
      `ifelse(`$2', `"icmp"', `"FromPort": "-1", "ToPort": "-1"',
                            `"FromPort": "0", "ToPort": "65535"')',
    `$4',`',
      `"FromPort": cfnArg(`$3'), "ToPort": cfnArg(`$3')',
    `"FromPort": cfnArg(`$3'), "ToPort": cfnArg(`$4')'
  )
')

define(`_alnum_only', `patsubst(`$1', `[^a-zA-Z0-9]*')')

#===========================================================
#
# The Ingress Rules
#
#===========================================================

#
# allowTcpFromCidrSGI(sg, id, src_cidr, startport[, endport] )

define(`_alnum_only', `patsubst(`$1', `[^a-zA-Z0-9]*')')

define(`allowTcpFromCidrSGI', `"_alnum_only(`$1r$2TcpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "tcp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowTcpFromSgSGI(sg, id, src_sg, startport[, endport ])

define(`allowTcpFromSgSGI', `"_alnum_only(`$1r$2TcpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "tcp", `$4', `$5'),
    "SourceSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowUdpFromCidrSGI(sg, id, src_cidr, startport[, endport] )

define(`allowUdpFromCidrSGI', `"_alnum_only(`$1r$2UdpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowUdpFromSgSGI(sg, id, src_sg, startport[, endport ])

define(`allowUdpFromSgSGI', `"_alnum_only(`$1r$2UdpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "SourceSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowUdpFromCidrSGI(sg, id, src_cidr, startport[, endport] )

define(`allowUdpFromCidrSGI', `"_alnum_only(`$1r$2UdpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowUdpFromSgSGI(sg, id, src_sg, startport[, endport ])

define(`allowUdpFromSgSGI', `"_alnum_only(`$1r$2UdpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "SourceSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowIcmpFromCidrSGI(sg, id, src_cidr, startport[, endport] )

define(`allowIcmpFromCidrSGI', `"_alnum_only(`$1r$2IcmpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "icmp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowIcmpFromSgSGI(sg, id, src_sg, startport[, endport ])

define(`allowIcmpFromSgSGI', `"_alnum_only(`$1r$2IcmpIn')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupIngress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "icmp", `$4', `$5'),
    "SourceSecurityGroupId": cfnArg(`$3')
  }
}')


#===========================================================
#
# The Egress Rules
#
#===========================================================

#
# allowTcpToCidrSGE(sg, id, src_cidr, startport[, endport] )

define(`_alnum_only', `patsubst(`$1', `[^a-zA-Z0-9]*')')

define(`allowTcpToCidrSGE', `"_alnum_only(`$1r$2TcpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "tcp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowTcpToSgSGE(sg, id, src_sg, startport[, endport ])

define(`allowTcpToSgSGE', `"_alnum_only(`$1r$2TcpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "tcp", `$4', `$5'),
    "DestinationSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowUdpToCidrSGE(sg, id, src_cidr, startport[, endport] )

define(`allowUdpToCidrSGE', `"_alnum_only(`$1r$2UdpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowUdpToSgSGE(sg, id, src_sg, startport[, endport ])

define(`allowUdpToSgSGE', `"_alnum_only(`$1r$2UdpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "DestinationSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowUdpToCidrSGE(sg, id, src_cidr, startport[, endport] )

define(`allowUdpToCidrSGE', `"_alnum_only(`$1r$2UdpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowUdpToSgSGE(sg, id, src_sg, startport[, endport ])

define(`allowUdpToSgSGE', `"_alnum_only(`$1r$2UdpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "udp", `$4', `$5'),
    "DestinationSecurityGroupId": cfnArg(`$3')
  }
}')

#
# allowIcmpToCidrSGE(sg, id, src_cidr, startport[, endport] )

define(`allowIcmpToCidrSGE', `"_alnum_only(`$1r$2IcmpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "icmp", `$4', `$5'),
    "CidrIp": cfnArg(`$3')
  }
}')


#
# allowIcmpToSgSGE(sg, id, src_sg, startport[, endport ])

define(`allowIcmpToSgSGE', `"_alnum_only(`$1r$2IcmpOut')": {
  _RESOURCETYPE(`AWS::EC2::SecurityGroupEgress'),
  "Properties": {
     _sg_group_proto_and_port_properties(`$1', "icmp", `$4', `$5'),
    "DestinationSecurityGroupId": cfnArg(`$3')
  }
}')





divert`'dnl
