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

[ -f "$FILE" ] || echo '[]' >"$FILE"

OUT=$(echo "${1:-$(cat -)}" | jq --compact-output)

INDEX=$(jq '. | length' "$FILE")

[ -z "$OUT" ] && exit 1

echo '[]' |
  add_json_with_ids --argjson j "$(cat /tmp/out.json)" --arg i 0 &&
  add_json_with_ids --argjson j "$OUT" \
    --arg i "$INDEX" "$FILE" >"$FILE.tmp" &&
  mv "$FILE.tmp" "$FILE" &&
  jq . "$FILE"
