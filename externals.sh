URL=http://svn.kuali.org/repos/student/sandbox/ks-1.3-core-slice-demo/modules

EXT1="ks-api $URL/ks-api/trunk"
EXT2="ks-core $URL/ks-core/trunk"
EXT3="ks-lum $URL/ks-lum/trunk"
EXT4="ks-enroll $URL/ks-enroll/trunk"

ARGS="'$EXT1' '$EXT2' '$EXT3' '$EXT4'"
ARGS="'$EXT1'"

echo $ARGS

svn propset svn:externals $ARGS .