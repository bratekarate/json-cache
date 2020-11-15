#!/bin/sh

FILE=${2:-$FILE}
FILE=${FILE:-/tmp/out.json}

[ -f "$FILE" ] ||
  {
    echo "Error: No file with JSON data found." >&2
    exit 1
  }

INDEX=${1:-'. | length - 1'}

case "$INDEX" in
a | A)
  echo '[]' >"$FILE"
  ;;
*)
  echo '[]' |
    add_json_with_ids --argjson j "$(jq "del(.[$INDEX])" "$FILE")" \
      --arg i 0 >"$FILE.tmp" &&
    mv "$FILE.tmp" "$FILE"
  ;;
esac || exit
jq . "$FILE"
