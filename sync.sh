#!/bin/sh -x

echo "starting sync loop"

NC_ROOT="$1"
DATA="$2"

echo "NC_ROOT $NC_ROOT"
echo "DATA $DATA"

while true; do
  echo "syncing appdata"

  APPDATA=`ls -d $DATA/appdata_* || true`
  if [ -n "$APPDATA" ]; then
      echo "appdata exists - syncing"
      # inotifywait -r -e modify,attrib,close_write,move,create,delete "$APPDATA"

      if [ "$(id -u)" = 0 ]; then
          rsync_options="-rlDog --chown www-data:root"
      else
          rsync_options="-rlD"
      fi
      # rsync $rsync_options --delete --exclude-from=/upgrade.exclude /usr/src/nextcloud/ /var/www/html/

      for dir1 in $APPDATA; do
          for dir2 in css js; do
              if [ -d "$dir1/$dir2" ]; then
                  rsync $rsync_options \
                  "$dir1/$dir2" "$NC_ROOT"
                  echo "Updated $dir2 folder"
              fi
          done
      done
  fi
  
  sleep 240
done