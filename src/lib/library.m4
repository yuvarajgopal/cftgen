divert(-1)             # -*- indent-tabs-mode: nil -*-

# LQUOTE creates a left quote
# LQUOTED cerated a left quoted string
# RQUOTE creates a right quote
define(`LQUOTE',`changequote(<,>)`dnl'
changequote`'')dnl
define(`LQUOTED', `LQUOTE`'$1`'LQUOTE')
define(`RQUOTE',`changequote(<,>)dnl`
'changequote`'')dnl
#
# quote(args) - convert args to single-quoted string
define(`quote', `ifelse(`$#', `0', `', ``$*'')')
# dquote(args) - convert args to quoted list of quoted strings
define(`dquote', ``$@'')
# dquote_elt(args) - convert args to list of double-quoted strings
define(`dquote_elt', `ifelse(`$#', `0', `', `$#', `1', ```$1''',
                             ```$1'',$0(shift($@))')')

# join(sep, args) - join each non-empty ARG into a single
# string, with each element separated by SEP

define(`join',
`ifelse(`$#', `2', ``$2'',
  `ifelse(`$2', `', `', ``$2'_')$0(`$1', shift(shift($@)))')')
define(`_join',
`ifelse(`$#$2', `2', `',
  `ifelse(`$2', `', `', ``$1$2'')$0(`$1', shift(shift($@)))')')
# joinall(sep, args) - join each ARG, including empty ones,
# into a single string, with each element separated by SEP
define(`joinall', ``$2'_$0(`$1', shift($@))')
define(`_joinall',
`ifelse(`$#', `2', `', ``$1$3'$0(`$1', shift(shift($@)))')')

# forloop_arg(from, to, macro) - invoke MACRO(value) for
#   each value between FROM and TO, without define overhead
define(`forloop_arg', `ifelse(eval(`($1) <= ($2)'), `1',
  `_forloop(`$1', eval(`$2'), `$3(', `)')')')

# forloop(var, from, to, stmt) - refactored to share code
define(`forloop', `ifelse(eval(`($2) <= ($3)'), `1',
  `pushdef(`$1')_forloop(eval(`$2'), eval(`$3'),
    `define(`$1',', `)$4')popdef(`$1')')')
define(`_forloop',
  `$3`$1'$4`'ifelse(`$1', `$2', `',
    `$0(incr(`$1'), `$2', `$3', `$4')')')

# foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, improved version

define(`foreach', `pushdef(`$1')_$0(`$1',
  (dquote(dquote_elt$2)), `$3')popdef(`$1')')
define(`_arg1', `$1')
define(`_foreach', `ifelse(`$2', `(`')', `',
  `define(`$1', _arg1$2)$3`'$0(`$1', (dquote(shift$2)), `$3')')')

dnl
dnl
dnl
dnl json(listify(item[, ...])
dnl   -- turn arguments into a [ list [, ...] ]
dnl
define(`json_listify', `[ join(`, ',$*) ]')dnl
dnl
dnl
dnl
define(`cfnRef', `{ "Ref" : "$1" }' )dnl
define(`cfnGetAttr', `{ "Fn::GetAtt" : [ `$1' , `$2' ] }')dnl
dnl
dnl
dnl cfnArg(x)
dnl    &x -> cfnRef(x)
dnl    number-> "number"
dnl    else unchnaged
dnl
define(`cfnArg',`dnl
ifelse(regexp(`$1',`^&'),0,  `regexp(`$1', `^&\(.*\)$',`cfnRef(\1)')',
  regexp(`$1', `^[0-9]+$'),0,`"$1"',
  `$1')')dnl
#
## was
##define(`cfnArg',`dnl
##ifelse(regexp(`$1',`^&'),0,  `regexp(`$1', `^&\(.*\)$',`cfnRef(\1)')',
##  regexp(`$1', `^"'),0,`$1',
##  regexp(`$1', `^\{'),0,`$1',
##  `"$1"')')dnl
dnl

# paste two, three, four, five, or six  arguments together via Fn::Join

define(`cfnPaste', `dnl
{ "Fn::Join" : [ "", [
                         cfnArg(`$1')
		       , cfnArg(`$2')
ifelse(`$3',`',`',`dnl
                       , cfnArg(`$3')
')dnl
ifelse(`$4',`',`',`dnl
                       , cfnArg(`$4')
')dnl
ifelse(`$5',`',`',`dnl
                       , cfnArg(`$5')
')dnl
ifelse(`$6',`',`',`dnl
                       , cfnArg(`$6')
')dnl
		     ]
	       ]
}')

#
# cfnFindInMap(map,key,attr)
#

define(`cfnFindInMap',
	`{ "Fn::FindInMap" : [ $1, cfnArg(`$2'), $3 ] }')dnl
#
# cfnHostname(host,domain)
#

define(`cfnHostname',
`{ "Fn::Join": [ "", [ cfnArg(`$1') , ".", cfnArg(`$2'), "."] ] }')dnl


#
# cfnSelect(index, list)
#
#   list is expected to be a parameter reference
#   remember: index is zero-based
#

define(`cfnSelect',
  `{ "Fn::Select" : [ cfnArg(`$1'), cfnArg(`$2') ] }'
)

#
# cfnEquals(x, y)
#

define(`cfnEquals',
  `{ "Fn::Equals" : [ cfnArg(`$1') , cfnArg(`$2') ] }'
)


#
# cfnAnd(x, y)
#

define(`cfnAnd',
  `{ "Fn::And" : [ cfnArg(`$1') , cfnArg(`$2') ] }'
)

#
# cfnOr(x, y)
#

define(`cfnOr',
  `{ "Fn::Or" : [ cfnArg(`$1') , cfnArg(`$2') ] }'
)


#
# cfnNot(x)
#

define(`cfnNot',
  `{ "Fn::Not" : [ cfnArg(`$1') ] }'
)

#
# cfnNotEquals(x,y)
#

define(`cfnNotEquals',
  `cfnNot(`cfnEquals(`cfnArg(`$1')', `cfnArg(`$2')')')'
)

#
# cfnIf(Condition, true-case, false-case)
#  -- if a case is empty, AWS::NoValue will be used
#

define(`cfnIf',
  `{ "Fn::If" : [ "$1" ,
                  ifelse(`$2', `', cfnRef(AWS::NoValue), cfnArg(`$2')),
                  ifelse(`$3', `', cfnRef(AWS::NoValue), cfnArg(`$3'))
                ] }'
)

#
# cfnCondition(x)
#

define(`cfnCondition',
  `{ "Condition" : cfnArg(`$1') }'
)

divert`'dnl
