dnl -*- mode: m4; indent-tabs-mode: nil -*-
divert(-1)

# autoscaling resources and related macros

#
# mkAbsoluteScalingPolicy(name,asgroup,change)
#

define(`mkAbsoluteScalingPolicy',`"$1" : {
  _RESOURCETYPE(`AWS::AutoScaling::ScalingPolicy'),
  "Properties" : {
    "AutoScalingGroupName" : cfnArg($2),
    "AdjustmentType" : "ChangeInCapacity",
    "ScalingAdjustment" : cfnArg($3)
  }
}')



divert`'dnl
