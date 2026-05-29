# cmux Cheat Sheet

One page, no fluff. See [`CHEATSHEET.md`](./CHEATSHEET.md).

## Generate a printable PDF

If you have [pandoc](https://pandoc.org) and a LaTeX engine installed:

```bash
pandoc CHEATSHEET.md -o cmux-cheatsheet.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=0.6in \
  -V mainfont="Inter" \
  -V monofont="JetBrains Mono"
```

Or open `CHEATSHEET.md` in any markdown viewer (including cmux's own — `cmux open CHEATSHEET.md`) and Cmd-P to print.
