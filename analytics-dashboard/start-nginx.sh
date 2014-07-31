#! /bin/sh

# Tom Kranz tom@siliconbunny.com
#
# Note that the nginx.conf file that is called is setup to have relative paths - you'll
# need to edit this and change those if you move the locations around

# For portability and ease of use, the config, content and logs all lives under the same
# directory tree

# Just grab our current working directory
export PWD=`pwd`

# And then feed that to nginx on the command line to call our custom config
nginx -p $PWD -c $PWD/nginx.conf
