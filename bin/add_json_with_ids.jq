#!/usr/bin/jq -f

def add_id(pr):
    [ foreach .[] as $o (
            $i|tonumber - 1;
            . + 1;
            $o + {"n": . }) ];

    . + ($j |
            if type == "object"
            then [. | {n: 0} + .]
            else .  end | 
            add_id(""))
