
ARGS=$@
echo $ARGS

conf=$(echo $ARGS| sed -e $'s/-/\\\n/g')

echo -e "$conf"

