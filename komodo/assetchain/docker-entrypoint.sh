#!/bin/sh

KOMODO_DATA=$KOMODO_DATA/$AC_NAME

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for komodod"
  set -- komodod "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "komodod" ] && [ $(echo "$2") != "-help" ]; then
  if [ -z ${AC_NAME+x} ]; then
    echo "You have to set AC_NAME environment variable to start this container"
    exit 1;
  fi
  mkdir -p "$KOMODO_DATA"
  chmod 700 "$KOMODO_DATA" "/home/komodo/.zcash-params"
  chown -R komodo "$KOMODO_DATA" "/home/komodo/.zcash-params"
  
  if [ -z "$(ls -A /home/komodo/.zcash-params)" ]; then
    alias exit=return
    gosu komodo /fetch-params.sh
  fi

  echo "$0: setting data directory to $KOMODO_DATA"

  set -- "$@" -datadir="$KOMODO_DATA"

  echo "$0: setting asset chain to $AC_NAME"

  set -- "$@" -ac_name="$AC_NAME"

  config=$(echo $@ | sed $'s/-/\\\n/g' | sed 's#\\##g' | grep -v komodod)
  echo "Generating configuration:\n${config}"
  echo "$config" > $KOMODO_DATA/$AC_NAME.conf

fi

if [ "$1" = "komodod" ] || [ "$1" = "komodo-cli" ] || [ "$1" = "komodo-tx" ]; then
  echo "Executing: $@"
  exec gosu komodo "$@"
fi

echo
exec "$@"
