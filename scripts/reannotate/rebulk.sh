#!/bin/bash

set -e

read -p 'Server:' host
host="${host:=localhost:4064}"

read -p 'Username: ' username
username="${username:=demo}"

read -sp 'Password: ' password

set -x

OMERO_DIST='/home/omero/OMERO.server'
IDR_METADATA='/tmp/idr-metadata'


create_bulk () {
    local object=${1:-};
    local path=${2:-};
    if [ -n "$object" ] &&[ -n "$path" ]; then
        # generate new table
        echo "generate new bulk annotation $object $path"
        $OMERO_DIST/bin/omero metadata populate --file $path-annotation.csv $object >> "log_create_bulk_$object" 2>&1
    fi
}

set +x
$OMERO_DIST/bin/omero login -u $username -w "$password" -s $host -C
echo "Logged in $username@$host"
set -x

while read -r obj path; do
    echo "#####  BEGINNING $obj $path  #####"

    # generate new table
    create_bulk $obj "$IDR_METADATA/$path"

    echo "#####  END $obj $path  #####"
done < demo33_input_bulk.txt
# IMPORTANT EOL

$OMERO_DIST/bin/omero logout
