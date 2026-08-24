# Warp Hiring Challenge — Space Mission Log Analysis

**Task:** find the security code of the **longest `Completed` `Mars` mission** in `space_missions.log`
(pipe-delimited: `Date | Mission ID | Destination | Status | Crew | Duration(days) | Success% | Security Code`).

## Answer

```
XRT-421-ZQP
```

Mission `WGU-0200` · 2065-06-05 · Mars · Completed · crew 4 · **1629 days** · 98.82% success.
It's the unique maximum (next longest Mars/Completed mission is 1482 days), so no tie-break is needed.

## Run it

```bash
awk -f solve.awk space_missions.log   # -> XRT-421-ZQP
./verify.sh                           # top-5 candidates + tie-check + final answer
./explore.sh                          # the recon I did first
```

## Approach (and the bugs I worked through)

The commit history walks through the real path rather than jumping to the final one-liner:

1. **Explore** (`explore.sh`) — inspect the file before trusting a parse. Findings: 100,000 valid
   8-field records + 2,038 junk lines (`SYSTEM:` / `CONFIG:` / `CHECKSUM:` / blanks), plus `#`
   comments, and heavy, *inconsistent* whitespace padding around fields.
2. **First pass (naive)** — skip `#` comments and require `NF == 8` to drop the junk lines (no brittle
   string matching needed). Bug: exact matches like `$3 == "Mars"` mostly failed because fields are
   padded (`"  Mars   "`). Wrong answer.
3. **Trim whitespace** — `gsub(/^[ \t]+|[ \t]+$/, "", $i)` on every field. Now all rows match, but the
   answer was still wrong: `$6 > max` compared Duration as a **string**, so `"99"` sorted above `"1629"`.
4. **Fix numeric comparison** — coerce with `$6 + 0`. Correct answer.
5. **Verify** (`verify.sh`) — print the top-5 candidates and confirm the winner (1629 days) is unique.

## Edge cases handled

- `#` comment lines (including indented ones) — dropped via `!/^[[:space:]]*#/`.
- Non-record junk lines — dropped via `NF == 8`.
- Inconsistent whitespace padding — trimmed on every field before comparing.
- String-vs-numeric comparison on Duration — forced numeric with `+ 0`.
- Verified there are no casing/whitespace decoys (`Mars`/`Completed` are always exact after trimming)
  and that the max duration is unique.

## Notes on tooling

Warp's challenge encourages solving this in **Agent Mode**, so I did — and treated the agent's output
the way I'd treat any generated code: I had it draft the `awk`, then verified it myself (checked the
numeric-vs-string comparison, ran a tie-check, and confirmed the candidate ranking) before trusting the
result. Knowing when to verify non-deterministic output is the point.
