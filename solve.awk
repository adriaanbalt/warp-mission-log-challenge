#!/usr/bin/awk -f
# v2 — trim inconsistent whitespace.
# v1 missed most rows: fields are padded like "  Mars   " / " Completed ", so exact
# string matches failed. Trim leading/trailing whitespace on every field first.
BEGIN { FS = "|" }

!/^[[:space:]]*#/ && NF == 8 {
    for (i = 1; i <= NF; i++) gsub(/^[ \t]+|[ \t]+$/, "", $i)
    if ($3 == "Mars" && $4 == "Completed" && $6 > max) {
        max  = $6
        code = $8
    }
}

END { print code }
