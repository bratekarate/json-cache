#!/bin/sh

while getopts ':abcdef:ghijklmnopqrstuvw' O; do
  case "$O" in
  f)
    FILE="$OPTARG"
    ;;
  *)
    RESTARGS="$RESTARGS-$O/"
    ;;
  esac
done
shift $((OPTIND - 1))

RESTARGS=$(echo "$RESTARGS" | sed 's|/$||g')

FILE=${FILE:-/tmp/jq_out.json}

[ -f "$FILE" ] || echo '[]' >"$FILE"

FILTER=.
[ -n "$1" ] && FILTER="$FILTER"["$1"] && shift
[ -n "$1" ] && FILTER="$FILTER$1" && shift

OLDIFS=$IFS
IFS='/'
set --
for i in $RESTARGS; do
  set -- "$@" "$i"
done
IFS=$OLDIFS

jq "$@" "$FILTER" "$FILE"
