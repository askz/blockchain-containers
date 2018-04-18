#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for komodod"
  echo "$@"
  set -- komodod "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "komodod" ] && [ $(echo "$1") != "-help" ]; then
  mkdir -p "$KOMODO_DATA"
  chmod 700 "$KOMODO_DATA" "/home/komodo/.zcash-params"
  chown -R komodo "$KOMODO_DATA" "/home/komodo/.zcash-params"

  if [ ! -f $KOMODO_DATA/komodo.conf ]; then
    touch $KOMODO_DATA/komodo.conf
  fi
  
  if [ -z "$(ls -A /home/komodo/.zcash-params)" ]; then
    alias exit=return
    gosu komodo /fetch-params.sh
  fi

  echo "$0: setting data directory to $KOMODO_DATA"

  set -- "$@" -datadir="$KOMODO_DATA"
  
    config=$(echo $@ | sed $'s/-/\\\n/g' | sed 's#\\##g' | grep -v komodod)
  echo "Generating configuration:\n${config}"
  echo "$config" > $KOMODO_DATA/komodo.conf
fi

if [ "$1" = "komodod" ] || [ "$1" = "komodo-cli" ] || [ "$1" = "komodo-tx" ]; then
  echo
  exec gosu komodo "$@"
fi

echo
exec "$@"
