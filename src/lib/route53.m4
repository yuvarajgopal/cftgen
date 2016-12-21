dnl
dnl
dnl r53HostAddr(name, hostname, domain, addr)
dnl
define(`r53HostAddr',`"$1" : {
  _RESOURCETYPE(`AWS::Route53::RecordSet'),
  "Properties" : {
    "Comment" : "",
    "HostedZoneName" : { "Fn::Join" : [ "", [ cfnArg(`$3'), "." ]]},
    "Name" : cfnHostname(`$2',`$3'),
    "Type" : "A",
    "TTL" : "300",
    "ResourceRecords" : [ cfnArg(`$4') ]
  }
}')dnl
dnl
dnl
dnl r53Cname(name, hostname, domain, cname)
dnl
define(`r53Cname',`"$1" : {
  _RESOURCETYPE(`AWS::Route53::RecordSet'),
  "Properties" : {
    "Comment" : "",
    "HostedZoneName" : { "Fn::Join" : [ "", [ cfnArg(`$3'), "." ]] },
    "Name" : cfnHostname(`$2',`$3'),
    "Type" : "CNAME",
    "TTL" : "300",
    "ResourceRecords" : [ cfnArg(`$4') ]
  }
}')dnl
dnl
dnl
dnl r53Weighted(name, hostname, domain, addr, healthcheck, identifier, weight)
dnl
define(`r53Weighted',`"$1" : {
  _RESOURCETYPE(`AWS::Route53::RecordSet'),
  "Properties" : {
    "Comment" : "",
    "HealthCheckId" : cfnArg(`$5'),
    "HostedZoneName" : { "Fn::Join" : [ "", [ cfnArg(`$3'), "." ] ] },
    "Name" : cfnHostname(`$2', `$3'), 
    "ResourceRecords" : [ cfnArg(`$4') ],
    "SetIdentifier" : cfnArg(`$6'),
    "TTL" : "30",
    "Type" : "A",
    "Weight" : cfnArg(`$7')
  }
}')dnl
dnl
dnl Can't tag health checks in CF yet
dnl r53HTTPHealthCheck(name, ip, resourcepath, failurethreshold, req interval)
dnl
define(`r53HTTPHealthCheck', `"$1" : {
  _RESOURCETYPE(`AWS::Route53::HealthCheck'),
  "Properties" : {
    "HealthCheckConfig" : {
      "FailureThreshold" : cfnArg(`$4'),
      "IPAddress" : cfnArg(`$2'),
      "Port" : "80",
      "ResourcePath" : cfnArg(`$3'),
      "Type" : "HTTP",
      "RequestInterval" : cfnArg(`$5')
    }
  }
}')dnl
dnl
dnl
dnl r53HTTPSHealthCheck(name, ip, resourcepath, failurethreshold, req interval)
dnl
define(`r53HTTPSHealthCheck', `"$1" : {
  _RESOURCETYPE(`AWS::Route53::HealthCheck'),
  "Properties" : {
    "HealthCheckConfig" : {
      "FailureThreshold" : cfnArg(`$4'),
      "IPAddress" : cfnArg(`$2'),
      "Port" : "443",
      "ResourcePath" : cfnArg(`$3'),
      "Type" : "HTTPS",
      "RequestInterval" : cfnArg(`$5')
    }
  }
}')dnl
