divert(-1)             # -*- indent-tabs-mode: nil -*-

#
#
#  support AWS Template Conditions

# CONDBLOCK([Conditional])
#    begin or end a conditional block
#    macros for resources that know about conditionals
#    will include a condition clause
#    if the Conditional name is supplied



define(`CONDBLOCK', `dnl
ifelse(`$1',`',
	`undefine(`_Current_Condition_')',
	`define(`_Current_Condition_', `$1')')
')dnl


divert`'dnl
