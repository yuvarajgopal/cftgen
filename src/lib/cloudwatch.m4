dnl -*- indent-tabs-mode: nil -*-
divert(-1)
dnl
dnl cwInstanceAlarm(name,instance,
dnl                 metric,namespace,statistic,
dnl                 limit,period,nPeriods,policy,comp)
dnl
define(`cwInstanceAlarm',`"$1" : {
  _RESOURCETYPE(`AWS::CloudWatch::Alarm'),
  "Properties" : {
    "Dimensions" : [ { "Name" : "InstanceId" , "Value" : cfnArg($2) } ],
    "AlarmDescription" : "cw Alarm ",
    "MetricName" : cfnArg(`$3'),
    "Namespace" : cfnArg(`$4'),
    "Statistic" : cfnArg(`$5'),
    "Threshold" : cfnArg(`$6'),
    "Period" : cfnArg(`$7'),
    "EvaluationPeriods" : cfnArg(`$8'),
    "AlarmActions" : [ cfnArg($9) ],
    "ComparisonOperator" : cfnArg(`$10')
   }
}')dnl
dnl
dnl
dnl cwRdsAlarm(name,instance,
dnl                 metric,namespace,statistic,
dnl                 limit,period,nPeriods,policy,comp)
dnl
define(`cwRdsAlarm',`"$1" : {
  _RESOURCETYPE(`AWS::CloudWatch::Alarm'),
  "Properties" : {
    "Dimensions" : [ { "Name" : "DBInstanceIdentifier" , "Value" : cfnArg($2) } ],
    "AlarmDescription" : "cw Alarm ",
    "MetricName" : cfnArg(`$3'),
    "Namespace" : cfnArg(`$4'),
    "Statistic" : cfnArg(`$5'),
    "Threshold" : cfnArg(`$6'),
    "Period" : cfnArg(`$7'),
    "EvaluationPeriods" : cfnArg(`$8'),
    "AlarmActions" : [ cfnArg($9) ],
    "ComparisonOperator" : cfnArg(`$10')
   }
}')dnl
dnl
dnl
dnl cwCpuAlarm(name,limit,period,nPeriods,policy, instance, comp)
dnl
define(`cwCpuAlarm',`"$1" : {
  _RESOURCETYPE(`AWS::CloudWatch::Alarm'),
  "Properties" : {
    "AlarmDescription" : "cpu ? translit(`$2',`"')% for translit(`$4',`"') translit(`$3',`"') second periods",
    "MetricName" : "CPUUtilization",
    "Namespace" : "AWS/EC2",
    "Statistic" : "Average",
    "Threshold" : cfnArg($2),
    "Period" : cfnArg($3),
    "EvaluationPeriods" : cfnArg($4),
    "AlarmActions" : [ cfnArg($5) ],

    "Dimensions" : [ { "Name" :"InstanceId",
                     "Value" : cfnArg($6) } ],
    "ComparisonOperator" : "$7"
   }
}')dnl
dnl
dnl
dnl
dnl cwCpuHighAlarm(name,limit,period,nPeriods,policy,group)
dnl cwCpuLowAlarm(name,limit,period,nPeriods,policy,group)
define(`cwHighCpuAlarm',
	`cwCpuAlarm(`$1',`$2',`$3',`$4',`$5',`$6',`GreaterThanThreshold')')dnl
define(`cwLowCpuAlarm',
	`cwCpuAlarm(`$1',`$2',`$3',`$4',`$5',`$6',`LessThanThreshold')')dnl
dnl


dnl
dnl cwGenericAlarm(name,metric,  limit,period,nPeriods,policy,group,comp)
dnl
dnl
define(`cwGenericAlarm',`"$1" : {
  _RESOURCETYPE(`AWS::CloudWatch::Alarm'),
  "Properties" : {
    "AlarmDescription" : "metric $8",
    "MetricName" : cfnArg(`$2'),
    "Namespace" : "AWS/EC2",
    "Statistic" : "Average",
    "Threshold" : cfnArg(`$3'),
    "Period" : cfnArg(`$4'),
    "EvaluationPeriods" : cfnArg(`$5'),
    "AlarmActions" : [ cfnArg(`$6') ],
    "Dimensions" : [ { "Name" : "InstanceId" ,
                     "Value" : cfnArg(`$7') } ],
    "ComparisonOperator" : "$8"
   }
}')dnl

dnl cw{High|Low}Net{In|Out}Alarm(name,limit,period,nPeriods,policy,group)

define(`cwHighNetInAlarm', `cwGenericAlarm(`$1', "NetworkIn",
                                           `$2', `$3',
                                           `$4', `$5', `$6',
                                           `GreaterThanThreshold')')
define(`cwLowNetInAlarm', `cwGenericAlarm(`$1', "NetworkIn",
                                           `$2', `$3',
                                           `$4', `$5', `$6',
                                           `LessThanThreshold')')

divert`'dnl
