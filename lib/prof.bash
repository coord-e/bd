#!/bin/bash

SCRIPT=$1
shift
TRACE_COMMANDS=$@

tmpdir=$(mktemp -d)
cp $SCRIPT $tmpdir/source.sh
tmpscript=$tmpdir/script.sh

while read -d ' ' line; do
cat << EOF >> $tmpscript
function sleep() { :; }

count_$line=0

function $line() {
  count_$line=\$((count_$line += 1))
}
EOF
done <<< "$TRACE_COMMANDS "

echo "source /code/source.sh &> /dev/null" >> $tmpscript

tr ' ' '\n' <<< $TRACE_COMMANDS | sed -e 's/\(.*\)/echo "\1 $count_\1"/g' >> $tmpscript

docker run --cpu-period=1000000 --cpu-quota=200000 -v $tmpdir:/code bash bash /code/$(basename $tmpscript)
