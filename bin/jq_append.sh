#!/bin/sh

TMP_OUT=/tmp/jq_tmp_out.json

trap 'exit' INT HUP
trap 'cleanup' EXIT

cleanup() {
  rm "$TMP_OUT" 2>/dev/null
}

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

[ -f "$FILE" ] && [ -s "$FILE" ] || echo '[]' >"$FILE"

cat "${1:--}" > "$TMP_OUT"

INDEX=$(jq '. | length' "$FILE")

[ -s "$TMP_OUT" ] || exit 1

echo '[]' |
  add_json_with_ids --argfile j "$TMP_OUT" \
    --arg i "$INDEX" "$FILE" >"$FILE.tmp" &&
  mv "$FILE.tmp" "$FILE" &&
  jq . "$FILE"
