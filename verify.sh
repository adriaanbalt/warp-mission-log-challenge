#!/usr/bin/env bash
# Don't trust a single number — verify the winner is real and unique.
set -euo pipefail

LOG="space_missions.log"

echo "== top 5 Mars + Completed missions by duration =="
awk -F'|' 'NF==8 {
    for (i=1;i<=8;i++) gsub(/^[ \t]+|[ \t]+$/,"",$i)
    if ($3=="Mars" && $4=="Completed") printf "%s\t%s\t%s\t%s\n", $6, $8, $1, $2
}' "$LOG" | sort -t$'\t' -k1,1 -nr | head -5

echo "== tie check: any other Mars+Completed row at the max duration (1629)? =="
awk -F'|' 'NF==8 {
    for (i=1;i<=8;i++) gsub(/^[ \t]+|[ \t]+$/,"",$i)
    if ($3=="Mars" && $4=="Completed" && ($6+0)==1629) print $0
}' "$LOG"

echo "== final answer =="
awk -f solve.awk "$LOG"
