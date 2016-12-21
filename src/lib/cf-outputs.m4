dnl -*- indent-tabs-mode: nil -*-
divert(-1)

#
#  macros for the Outputs section
#
#  vvvvvv---- needs to be depracated!!!
#  output(entitity, description)
#
define(`output',`"$1" : {
  "Description" : "$2",
  "Value" :  { "Ref" : "$1" }
}')


define(`outputValue',`"$1" : {
  "Description" : "$2",
  "Value" :  { "Ref" : "$1" }
}')

#
#  outParam(Name, Type, Description)
define(`outParam',`"$1" : {
  "Description" : "$2",
  "Value" : { "Fn::Join" : [ "", [
    "`param'$2($1, LQUOTE`'$3`'RQUOTE, ",
    cfnRef($1),
    ")"
    ]
  ] }
}')



divert`'#
