dnl -*- indent-tabs-mode: nil -*-
divert(-1)
dnl

#
# mkSnsTopic(name, protocol, endpoint)
#
define(`mkSnsTopic', `"$1": {
  _RESOURCETYPE(`AWS::SNS::Topic'),
  "Properties" : {
    "Subscription" : [ {
      "Endpoint" : cfnArg(`$3') ,
      "Protocol" : cfnArg(`$2')
     } ]
  }
}')

divert`'dnl
