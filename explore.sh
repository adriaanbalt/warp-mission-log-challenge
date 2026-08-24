#!/usr/bin/env bash
# Recon: understand the shape of the file before trusting any parse.
set -euo pipefail

LOG="space_missions.log"

echo "== total lines =="
wc -l "$LOG"

echo "== first rows (see the padding + comment/junk lines) =="
sed -n '1,20p' "$LOG"

echo "== field-count distribution for non-comment lines =="
# Real records are pipe-delimited with 8 fields. Junk lines (SYSTEM:/CONFIG:/CHECKSUM:/blank)
# won't have 8 fields, so NF is a clean filter.
awk -F'|' '!/^[[:space:]]*#/ && NF>0 {c[NF]++} END{for(n in c) print n, c[n]}' "$LOG" | sort -n

echo "== sanity: are there casing/whitespace variants of Mars / Completed? =="
awk -F'|' 'NF==8{d=$3; gsub(/^[ \t]+|[ \t]+$/,"",d); if(tolower(d)~/mars/) print d}' "$LOG" | sort | uniq -c
awk -F'|' 'NF==8{s=$4; gsub(/^[ \t]+|[ \t]+$/,"",s); if(tolower(s)~/complet/) print s}' "$LOG" | sort | uniq -c
