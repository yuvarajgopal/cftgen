# cftgen

## 2.6.3

* (vpc.m4) added mkNatGateway()
* (library.m4) added LQUOTED macro to emit a `quoted` string

## 2.6.1 (v2.6.1)

* new macros for creating sg rules
* moved sg rules to lib/security-groups.m4 (out of vpc.m4)


## 2.5.1 (v2.5.1)

* Added support for EC2 Placement groups and Tenancy
  * paramTenancy()
  * paramPlacementGroup() and paramPlacementStrategy() macros
  * mkPlacementGroup() macro
* Added paramIpAddress() macro
* Added paramCname() macro
* Added the cfnIf() conditional function
* Move change history from the shell script into  (CHANGELOG.md)
* Add many default descriptions to the cf-params


## 2.4.2 (v2.4.2)

* Macros to create a customer gateway [NS]

## 2.4.1 (v2.4.1)

* add the -D to pass definitions to m4

## 2.3.1 (v2.3.1)

* add the m4 forloop in library.m4

## 2.2.8 (v2.2.8)

* add t2.large to instance types

## 2.2.7 (v2.2.7)

* add more instance types, mostly for db.*b [NS]

## 2.2.6 (v2.2.6)

* add c4.* instance types to cf-params

## 2.2.5 (v2.2.5)

* create a globals.m4 for configuration settings
* change some EBS handling

## 2.2.4 (v2.2.4)

* VERSION macro

## 2.2.3 (v2.2.3)

* r53 healthcheck macros [NS]

## 2.2.2 (v2.2.2)

* vpcpeer support

## 2.2.1 (v2.2.1)

* added conditional functions
* new volume parameters

## 2.1.8 (v2.1.8)

* added current instance types
* fixed new tags

## 2.1.7 (v2.1.7)

* added macros to support BootPriority and Purpose params

## 2.1.6 (v2.1.6)

* added macros to support VPN Gateways

## 2.1.5 (v2.1.5)

* converted all .m4's to use _RESOURCETYPE()
* moved last two resources out of mkTemplate

## 2.1.4 (v2.1.4)

* moved some macros out of mkTemplate
* added the _RESOURCETYPE() macro to vpc.m4 resources


## 2.1.3 (v2.1.3)

* change var names
* added the -L and -B options


## 2.1.2 (v2.1.2)

* version bump
* include version in help message


## 2.1.1 (v2.1.1)

* add CONDBLOCK() and some conditional processing
