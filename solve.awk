#!/usr/bin/awk -f
# v3 — final. Force a NUMERIC comparison on Duration.
# v2 compared $6 as a string, so "99" sorted above "1629". Coerce to number with `+ 0`.
#
# Fields: Date | Mission ID | Destination | Status | Crew | Duration(days) | Success% | SecurityCode
# Find: security code ($8) of the longest ($6) Mars ($3) mission with status Completed ($4).
BEGIN { FS = "|" }

!/^[[:space:]]*#/ && NF == 8 {
    for (i = 1; i <= NF; i++) gsub(/^[ \t]+|[ \t]+$/, "", $i)   # trim padding on every field
    if ($3 == "Mars" && $4 == "Completed" && ($6 + 0) > max) {  # $6 + 0 => numeric compare
        max  = $6 + 0
        code = $8
    }
}

END { print code }
