divert(-1)
# s3 macros

#
# create a simple s3 bucket
# 
# S3Bucket(resource,name)
#

define(`S3Bucket',`"$1": {
  _RESOURCETYPE(`AWS::S3::Bucket'),
  "Properties": {
    "BucketName": cfnArg(`$2'),
    "Tags": cfnTagList("$1")
  }
}
')dnl
		
divert`'dnl
