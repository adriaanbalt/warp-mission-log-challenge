#!/usr/bin/awk -f
# v1 — naive first pass.
# Goal: security code ($8) of the longest ($6) Mars ($3) mission with status Completed ($4).
# Skip comment lines; require 8 fields to drop the junk (SYSTEM:/CONFIG:/CHECKSUM:).
BEGIN { FS = "|" }

!/^[[:space:]]*#/ && NF == 8 {
    if ($3 == "Mars" && $4 == "Completed" && $6 > max) {
        max  = $6
        code = $8
    }
}

END { print code }
