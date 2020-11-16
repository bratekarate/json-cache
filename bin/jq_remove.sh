#!/bin/sh

while getopts ':abcdef:ghijklmnopqrstuvwxyz' O; do
  case "$O" in
  f)
    FILE="$OPTARG"
    ;;
  *)
    echo "Error: unknown parameter -$O" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

FILE=${FILE:-/tmp/jq_out.json}

[ -f "$FILE" ] ||
  {
    echo "Error: No file with JSON data found." >&2
    exit 1
  }

LAST='. | length - 1'

case "$1" in
a | A)
  echo '[]' >"$FILE"
  ;;
*)
  if [ -n "$1" ]; then
    if echo "$1" | grep -q ':'; then
      I_0=$(echo "$1" | cut -d ':' -f1)
      I_N=$(echo "$1" | cut -d ':' -f2)

      [ -z "$I_0" ] && I_0=0

      [ -z "$I_N" ] && I_N=$(jq "$LAST" "$FILE")

      I_N=$((I_N + 1))

      INDEX="range($I_0;$I_N)"
    else
      INDEX="$1"
    fi
  else
    INDEX=$LAST
  fi

  echo '[]' |
    add_json_with_ids --argjson j "$(jq "del(.[$INDEX])" "$FILE")" \
      --arg i 0 >"$FILE.tmp" &&
    mv "$FILE.tmp" "$FILE"
  ;;
esac || exit

jq . "$FILE"
