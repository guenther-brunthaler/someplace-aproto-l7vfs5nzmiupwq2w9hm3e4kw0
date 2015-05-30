#! /bin/sh
set -e
tool=autoreconf
trap 'test $? = 0 || echo "$tool failed!" >& 2' 0
touch NEWS README AUTHORS ChangeLog
$tool -i
if test $# != 0
then
	tool=./configure
	$tool "$@"
fi
