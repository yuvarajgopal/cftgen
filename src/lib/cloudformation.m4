divert(-1)             # -*- indent-tabs-mode: nil -*-

#
# mkWaitConditionHandle(name)
#
define(`mkWaitConditionHandle',`"$1" : {
  _RESOURCETYPE(`AWS::CloudFormation::WaitConditionHandle')
}')

#
#
# mkWaitCondition(name, dependson, handle[, seconds][, count])
#
define(`mkWaitCondition',`"$1" : {
  _RESOURCETYPE(`AWS::CloudFormation::WaitCondition'),
  "DependsOn" : $2,
  "Properties" : {
    "Handle" : cfnArg(`$3'),
ifelse(`$5', `', `', `"Count": cfnArg(`$5'),')
    "Timeout" : ifelse(`$4',`',`"1200"',`cfnArg(`$4')')
  }
}')dnl
#
#


divert`'dnl
