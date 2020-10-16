#!/bin/sh

FILE=${2:-$FILE}
FILE=${FILE:-/tmp/out.json}

[ -f "$FILE" ] ||
	{
		echo "Error: No file with JSON data found." >&2
		exit 1
	}

INDEX=${1:-'. | length - 1'}

jq "del(.[$INDEX])" "$FILE" >"$FILE.tmp" &&
	mv "$FILE.tmp" "$FILE" &&
	jq . "$FILE"
