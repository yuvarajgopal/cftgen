divert(-1)		       # -*- indent-tabs-mode: nil -*-
#
#
# macros related to VPCs and networking
#

include(`network-constants.m4')

dnl
dnl mkVpc(name, cidr[, name])
dnl
define(`mkVpc',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::VPC'),
   "Properties" : {
     "CidrBlock" : cfnArg(`$2'),
ifelse(`$3',`',
        `"Tags" : cfnTagList("tagPrefix`'$1_VPC")',
        `"Tags" : cfnTagList(`$3')')
   }
}')dnl
dnl
#
#

# dhcpOptions( name, Domain, [, dnsIps [, ntpIps ]] )

define(`mkDhcpOptions', `"$1": {
  _RESOURCETYPE(`AWS::EC2::DHCPOptions'),
        "Properties" : {
          "DomainName" : cfnArg(`$2'),
ifelse(`$3', `', `', `"DomainNameServers" : json_listify(`$3'),')
ifelse(`$4', `', `', `"NtpServers" : json_listify(`$4'),')
          "Tags" :  cfnTagList("tagPrefix`'DHCPOPTS")
        }
}')


# assocDhcpOptions2Vpc(opts, vpc)

define(`assocDhcpOptions2Vpc', `"dhcpoptassoc": {
  _RESOURCETYPE(`AWS::EC2::VPCDHCPOptionsAssociation'),
  "Properties" : {
      "VpcId": cfnArg(`$2'),
      "DhcpOptionsId" : cfnArg(`$1')
   }
}')


# mkInternetGateway(name)

define(`mkInternetGateway',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::InternetGateway'),
  "Properties" : {
    "Tags" : cfnTagList("tagPrefix`'$1_IGW")
  }
}')

# attInternetGateway2Vpc(name, igw, vpc)

define(`attInternetGateway2Vpc',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::VPCGatewayAttachment'),
  "Properties" : {
    "VpcId" : cfnArg(`$3'),
    "InternetGatewayId" : cfnArg(`$2')
  }
}')

dnl
dnl mkRouteTable(name,vpc)
dnl
define(`mkRouteTable',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::RouteTable'),
  "Properties" : {
     "VpcId" : cfnArg(`$2'),
     "Tags" : cfnTagList("$1")
   }
}')dnl
dnl
dnl
dnl mkInstanceRoute(name,RouteTable,CIDR,instance)
dnl
define(`mkInstanceRoute',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::Route'),
  "Properties" : {
     "RouteTableId" : cfnArg(`$2'),
     "DestinationCidrBlock" : cfnArg(`$3'),
     "InstanceId" : cfnArg(`$4')
   }
}')dnl
dnl
dnl
dnl mkGateWayRoute(name,RouteTable,CIDR,vgw)
dnl
define(`mkGatewayRoute',`"routeTo$1" : {
  _RESOURCETYPE(`AWS::EC2::Route'),
  "Properties" : {
     "RouteTableId" : cfnArg(`$2'),
     "DestinationCidrBlock" : cfnArg(`$3'),
     "GatewayId" : cfnArg(`$4')
   }
}')dnl

#
# mkVpcPeerRoute(name, RouteTable, CIDR, vpcpeerid)
#
define(`mkVpcPeerRoute',`"routeTo$1" : {
  _RESOURCETYPE(`AWS::EC2::Route'),
  "Properties" : {
     "RouteTableId" : cfnArg(`$2'),
     "DestinationCidrBlock" : cfnArg(`$3'),
     "VpcPeeringConnectionId" : cfnArg(`$4')
   }
}')dnl

#
# mkNatGwRoute(name, RouteTable, CIDR, natgwid)

define(`mkNatGwRoute',`"routeTo$1" : {
  _RESOURCETYPE(`AWS::EC2::Route'),
  "Properties" : {
     "RouteTableId" : cfnArg(`$2'),
     "DestinationCidrBlock" : cfnArg(`$3'),
     "NatGatewayId" : cfnArg(`$4')
   }
}')dnl

dnl mkVpcElasticIP(name [, instance])
dnl
define(`mkVpcElasticIP',` "$1" : {
  _RESOURCETYPE(`AWS::EC2::EIP'),
  "Properties" : {
ifelse(`$2',`',`',`dnl
     "InstanceId" : { "Ref" : "$2" },')
     "Domain" : "vpc"
   }
}')dnl
dnl
dnl
dnl mkVpcSubnet(name, vpc, subnetconfigkey, az[, mappublicip])
dnl
define(`mkVpcSubnet',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::Subnet'),
  "Properties" : {
     "VpcId" :  cfnArg(`$2'),
     "AvailabilityZone" : cfnArg(`$4'),
     "CidrBlock" : cfnFindInMap("SubnetConfig", cfnArg(`$3'), "CIDR"),
     ifelse(`$5', `', `',
                      `"MapPublicIpOnLaunch": cfnArg(`$5'),')
     "Tags" : cfnTagList("$1")
    }
}')dnl

# dnl
# this version can lookup up the az from teh subnetconfig map iff
#      the "AZ" key has teh literal az (e.g., us-east-1a)
#
# dnl mkVpcSubnet(name, vpc, subnetconfigkey)
# dnl
# define(`mkVpcSubnet',`"$1" : {
#   "Type" : "AWS::EC2::Subnet",
#   "Properties" : {
#      "VpcId" :  { "Ref" : "$2" },
# #     "AvailabilityZone" : "$4",
#      "AvailabilityZone" : cfnFindInMap("SubnetConfig", $3, "AZ"),
# #     "CidrBlock" : { "Fn::FindInMap" : [
# #       "SubnetConfig", $3,
# #       "CIDR"
# #       ]
#      "CidrBlock" : cfnFindInMap("SubnetConfig", $3, "CIDR"),
#      "Tags" : cfnTagList("$1")
#     }
# }')dnl

dnl
dnl
dnl assocSubnet2RouteTable(assocName, subnet,routeTable)
dnl
define(`assocSubnet2RouteTable',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::SubnetRouteTableAssociation'),
  "Properties" : {
     "SubnetId" : cfnArg(`$2'),
     "RouteTableId" : cfnArg(`$3')
  }
}')dnl

dnl
dnl assocNetworkAcl2Subnet(acl,subnet)
dnl
define(`assocNetworkAcl2Subnet',`"translit(`$2',`-"&',`xxx')NetworkAclAssoc" : {
  _RESOURCETYPE(`AWS::EC2::SubnetNetworkAclAssociation'),
  "Properties" : {
     "NetworkAclId" : cfnArg(`$1'),
     "SubnetId" : cfnArg(`$2')
   }
}')dnl


#
# aclAllowIn(name, acl, ruleno, proto, port, cidr [, toport])
#
# sorry for the ports being disjoint in the param list
# i am tring to maintain backward compatibility
#
define(`aclAllowIn',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::NetworkAclEntry'),
  "Properties" : {
    "NetworkAclId": cfnArg($2),
    "Egress" : "false",
    "RuleAction" : "Allow",
    "RuleNumber" : cfnArg(`$3'),
    "Protocol" : cfnArg(`$4'),
    "CidrBlock" : cfnArg(`$6'),
    "PortRange" : { "From": cfnArg(`$5'), "To": dnl
ifelse(`$7',`', `cfnArg(`$5')', `cfnArg(`$7')') }
  }
}')dnl
dnl

#
# aclAllowOut(name, acl, ruleno, proto, port, cidr [, toport])

define(`aclAllowOut',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::NetworkAclEntry'),
  "Properties" : {
    "NetworkAclId": cfnArg($2),
    "Egress" : "true",
    "RuleAction" : "Allow",
    "RuleNumber" : cfnArg(`$3'),
    "Protocol" : cfnArg(`$4'),
    "CidrBlock" : cfnArg(`$6'),
    "PortRange" : { "From": cfnArg(`$5'),
                    "To": ifelse(`$7',`', `cfnArg(`$5')', `cfnArg(`$7')')
                  }
  }
}')

#
# mkNetworkAcl(name, vpc)

define(`mkNetworkAcl',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::NetworkAcl'),
  "Properties" : {
    "VpcId" : $2,
     "Tags" : cfnTagList("tagPrefix`'$1_NETACL")
  }
}')



#
# mkCustomerGateway(name, type, ip, bgpasn)
#
define(`mkCustomerGateway', `"$1" : {
  _RESOURCETYPE(`AWS:EC2::CustomerGateway'),
  "Properties" : {
    "BgpAsn" : cfnArg(`$4'),
    "IpAddress" : cfnArg(`$3'),
    "Type" : cfnArg(`$2'),
    "Tags" : cfnTagList("tagPrefix`'$1_CustomerGW")
  }
}')

#
# mkVpnGateway(name, type)
#
define(`mkVpnGateway', `"$1" : {
  _RESOURCETYPE(`AWS::EC2::VPNGateway'),
  "Properties" : {
    "Type" : cfnArg(`$2'),
    "Tags" : cfnTagList("tagPrefix`'$1_VPNGW")
  }
}')

define(`attVpnGateway2Vpc',`"$1" : {
  _RESOURCETYPE(`AWS::EC2::VPCGatewayAttachment'),
  "Properties" : {
    "VpcId" : cfnArg(`$3'),
    "VpnGatewayId" : cfnArg(`$2')
  }
}')


#
# mkNatGateway(name, subnetid, eipalloc)

define(`mkNatGateway', `"$1" : {
  _RESOURCETYPE(`AWS::EC2::NatGateway'),
  "Properties" : {
    "SubnetId" : cfnArg(`$2'),
    "AllocationId" : cfnArg(`$3')
   }
}')




divert`'dnl
