dnl -*- mode: m4; indent-tabs-mode: nil -*-
divert(-1)

# iam resources and policy document macros

#
# mkAccessKey(name,username)
#

define(`mkAccessKey',`"$1" : {
  _RESOURCETYPE(`AWS::IAM::AccessKey'),
  "Properties" : {
     "UserName" : { "Ref": "$2" }
  }
}')dnl

#
#
# policyAllow(principal, actions, resource)
#

define(`policyAllow',`{
  "Effect" : "Allow",
  "Principal" : { "AWS": $1 },
  "Action" : [ join(`,', `$2') ],
  "Resource" : cfnArg($3)
}'dnl
)dnl

dnl define(`_policyDocument',`dnl
dnl "PolicyDocument": {
dnl   "Id": "$1",
dnl   "Statement":  [
dnl  ]

#
# mkIamGroup(name, allow [, deny])
#
# example:
#     mkIamGroup(SysOp, `"ec2:*"', `"ec2:Delete*","ec2:Terminate*"')
#
define(`mkIamGroup', `"$1" : {
  _RESOURCETYPE(`AWS::IAM::Group'),
  "Properties" : {
    "Policies" : [ {
      "PolicyName" : "$1",
      "PolicyDocument" : {
        "Statement" : [
        _iam_pd_stat("Allow",`$2',"*")
ifelse(`$3',`',`',`,_iam_pd_stat("Deny",`$3',"*")')
                      ]
                         }
                    }
      ]
      }

}')dnl

#
# internal
#  _iam_pd_stat(effect, action, resource)
#
#  example:
#    _iam_pd_stat(`"Allow"', `"ec2:*","sns:*"', "*")
#
define(`_iam_pd_stat',`{
  "Effect" : `$1',
  "Action" : json_listify(`$2'),
  "Resource" : `$3'
}')

#
# mkIamInstanceprofile(name, path, role)
# currently, only one role can be sepcified, so I make the list

define(`mkIamInstanceProfile',`"$1": {
  _RESOURCETYPE(`AWS::IAM::InstanceProfile'),
    "Properties" : {
      "Path" : cfnArg(`$2'),
      "Roles" : [ cfnArg(`$3') ]
    }
  }')



#
# mkIamRole(name, path, resource, allow [, deny])
#

define(`mkIamRole', `"$1": {
  _RESOURCETYPE(`AWS::IAM::Role'),
  "Properties": {
    "AssumeRolePolicyDocument": {
      "Statement": [ {
        "Effect": "Allow",
        "Principal": {
        "Service": [ "ec2.amazonaws.com" ]
      },
      "Action": [ "sts:AssumeRole" ]
      } ]
    },
    "Path": cfnArg(`$2'),
    "Policies": [ {
      "PolicyName": "$1",
        "PolicyDocument": {
        "Statement" : [
          _iam_pd_stat("Allow",`$4',`$3' )
ifelse(`$5',`',`',`,_iam_pd_stat("Deny",`$5',`$3')')
        ]
        }
      }
      ]
    }
  }')dnl


divert`'dnl
