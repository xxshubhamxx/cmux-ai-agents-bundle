#!/bin/bash
# Usage: ./recipe.sh https://example.com "#submit"
set -euo pipefail
URL="$1"; SEL="$2"
# `cmux --json browser open` returns the new browser surface; grab its short ref
# (e.g. surface:7). The surface handle is passed as the first positional token.
SURF=$(cmux --json browser open "$URL" | grep -oE 'surface:[0-9]+' | head -1)
cmux browser "$SURF" wait --selector "$SEL" --timeout-ms 15000
cmux browser "$SURF" snapshot --interactive
# Look up ref for $SEL in the snapshot output, then:
# cmux browser "$SURF" click eN
