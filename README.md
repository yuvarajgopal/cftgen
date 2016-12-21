
CFTGEN
======

The cftgen tool converts a CF template that was written as a .cf4 file
into a .cft (_c_loud _f_ormation _t_emplate) file, which is the JSON
the AWS expects.

The .cf4 is converted using a m4 macro library.

The Makefile can do a very simple instillation.  This is hard coded to
put a bin/ and lib/ directory under /usr/local/aws/cf.  You will need
to make sure /usr/local/aws/cf directory exists, and that you have
write access to it.

You should put /usr/local/aws/cf/bin in your path.

You will also probably want to put the latest version of provision_aws
in /usr/local/aws/cf/bin so that it will be available for you across
projects.

You may also need to set the CFTOOLSHOME environment variable.  It
defaults to /usr/local/aws/cf.

Notes
-----

1. This cftgen is not compatible with the original cftgen that was
developed for Ready2Go.  When working with Ready2Go provisioning,
unless specifically documented otherwise, you must use its cftgen.
