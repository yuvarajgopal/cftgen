divert(-1)             # -*- indent-tabs-mode: nil -*-

include(`globals.m4')
include(`library.m4')

define(`INCLUDE',`include(`$1')')
define(`projectTag',`NOPROJECT')
define(`environmentTag',`NOENVIRONENT')
define(`tagPrefix',`')

define(`_cft_version_',`0.0.0')
define(`VERSION',`define(`_cft_version_', `$1')')


define(`TEMPLATE',`dnl
  "AWSTemplateFormatVersion" : "2010-09-09",
  "Description" : "$1 [_cft_version_]"')

define(`TAGPREFIX',`define(`tagPrefix',`$1')dnl')
dnl don't use PROJECT and ENVIRONMENT
define(`PROJECT',`define(`projectTag',`$1')dnl')
define(`ENVIRONMENT',`define(`environmentTag',`$1')dnl')


include(`cf-params.m4')
include(`cf-conditionals.m4')
include(`cf-outputs.m4')
include(`autoscaling.m4')
include(`cloudformation.m4')
include(`iam-policy.m4')
include(`ec2-instance.m4')
include(`ebs.m4')
include(`route53.m4')
include(`cloudwatch.m4')
include(`cf-cloudinit.m4')
include(`s3.m4')
include(`sns.m4')
include(`vpc.m4')
include(`security-groups.m4')

#
# _RESOURCETYPE(type)
#  declare the aws resource type
#  and, optionally, insert a condition clause

define(`_RESOURCETYPE', `dnl
  "Type" : "$1"
ifdef(`_Current_Condition_', `  ,"Condition" : "_Current_Condition_"dnl
')dnl
ifdef(`_Current_CreationPolicy_',
         `  ,"CreationPolicy" : {
               "ResourceSignal": {
                 "Count": "_Current_CreationPolicy_Count_",
                 "Wait": "_Current_CreationPolicy_Wait_"
               }
             }')dnl
ifdef(`_Current_DeletionPolicy_', `  ,"DeletionPolicy" : "_Current_DeletionPolicy_"dnl
')
')


#
# DELETIONPOLICY()
#
#    begin or end a deletion policy  block
#    macros for resources that know about conditionals
#    will include a condition clause
#    if the Conditional name is supplied


define(`DELETIONPOLICY', `dnl
ifelse(`$1',`',
        `undefine(`_Current_DeletionPolicy_')',
        `define(`_Current_DeletionPolicy_', `$1')')
')dnl

#
# CREATIONPOLICY(count, wait)
#
#    begin or end a creation policy  block
#    macros for resources that know about conditionals
#    will include a condition clause
#    if the Conditional name is supplied


define(`CREATIONPOLICY', `dnl
ifelse(`$1',`',
# clear
        `undefine(`_Current_CreationPolicy_')
         undefine(`_Current_CreationPolicy_Count_')
         undefine(`_Current_CreationPolicy_Wait')',
#set
        `define(`_Current_CreationPolicy_', `true')
         define(`_Current_CreationPolicy_Count_', `$1')
         define(`_Current_CreationPolicy_Wait_', `$2')'
)
')



dnl
dnl cfnJoinInclude(filename)
dnl
define(`cfnJoinInclude',`dnl
{ "Fn::Join" :  [ "" , [
include($1)dnl
  ] ]
}')dnl
dnl
dnl deprecated...  this was used for the original r2g
dnl cfnMakeInstallSh(filename,cfnConfigSet,hostname)
dnl
define(`cfnMakeInstallSh',`{ "Fn::Base64" : { "Fn::Join" : [ "", [
define(`_cfnConfig',`$2')dnl
define(`_cfnHostname',`$3')dnl
include($1)dnl
  ] ] }
}')dnl
dnl
dnl
dnl
dnl cfnMakeUserData(filename)
dnl
define(`cfnMakeUserData',`{ "Fn::Base64" : { "Fn::Join" : [ "", [
include($1)dnl
  ] ] }
}')dnl

#
#  cfnTagList(name)
#     -- make a generic tag list
#

define(`cfnTagList',`[
  cfnMkTag("Name",`cfnArg(`$1')'),
  cfnMkTag("Application", `&AWS::StackName'),
  cfnMkTag("environment", &Environment),
  cfnMkTag("project", &Project)
]')dnl

#
#  cfnInstanceTagList(name)
#    -- make a instnace tag lists (includes some special params)
#

define(`cfnInstanceTagList',`[
  cfnMkTag("Name",`cfnArg(`$1')'),
  ifdef(`_PARAM_BOOT_PRIORITY',
     `cfnMkTag("BootPriority", `&BootPriority'),')
  ifdef(`_PARAM_PURPOSE',
     `cfnMkTag("Purpose", `&Purpose'),')
  cfnMkTag("Application", `&AWS::StackName'),
  cfnMkTag("environment", &Environment),
  cfnMkTag("project", &Project)
]')dnl

#
# cfnAsgTagList(name)   for auto scaling groups
#

define(`cfnAsgTagList',`[
  cfnMkTag("Name",$1,true),
  ifdef(`_PARAM_BOOT_PRIORITY',
     `cfnMkTag("BootPriority", `&BootPriority', true),')
  ifdef(`_PARAM_PURPOSE',
     `cfnMkTag("Purpose", `&Purpose', true),')
  cfnMkTag("Application", cfnRef(AWS::StackName),true),
  cfnMkTag("environment", &Environment, true),
  cfnMkTag("project", &Project, true)
]')dnl
dnl
dnl
dnl cfnMkTag(key,  value [, PalBool])
dnl
define(`cfnMkTag',`{ "Key" : $1, dnl
"Value" : cfnArg(`$2')`'dnl
ifelse(`$3',`',`',`, "PropagateAtLaunch" : "$3"')dnl
}')dnl
dnl

divert`'dnl
