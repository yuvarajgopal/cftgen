dnl
dnl macros for cloudinit linkage
dnl
dnl
dnl cfnFilePermissionCIMD(owner,group,perm)
define(`cfnFilePermissionCIMD',`dnl
"owner" : "$1", "group" : "$2", "mode"  : "$3"')dnl
dnl
dnl
dnl cimdChefRoles(role[,...])
dnl
define(`cfnChefRolesCIMD',`dnl
"/etc/chef/roles.json" : {
  cfnFilePermissionCIMD(root,root,000644),
  "content" : {
     "run_list" : [ dnl
define(`_comma',`')dnl
foreach(`x',($*),`_comma`'"role[x]"undefine(`_comma')define(`_comma',`,')')dnl
]
undefine(`_comma')dnl
  }
}')dnl
dnl
dnl ***WARNING***
dnl 
dnl cfnChefRolesCIMD is allegedly broken
dnl it generates one too many closing braces
dnl do not use it anymore!!!!
dnl 
dnl
dnl cfnChefRolesCIMD(role[,...])
dnl
define(`cfnChefRolesCIMD',`dnl
"/etc/chef/roles.json" : {
  cfnFilePermissionCIMD(root,root,000644),
  "content" : {
     "run_list" : [ dnl
define(`_comma',`')dnl
foreach(`x',($*),`_comma`'"role[x]"undefine(`_comma')define(`_comma',`,')')dnl
]
undefine(`_comma')dnl
  }
}')dnl
dnl
