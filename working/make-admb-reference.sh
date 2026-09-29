#!/bin/sh
# Build and install the original ADMB-based FLa4a (branch master) into a
# separate library, so the RTMB version can be compared against it.
# The scripts in scripts/ expect it in /tmp/claude-0/reflib; change REF/LIB
# (and the paths in the scripts) to suit.
set -e
REF=${REF:-/tmp/claude-0/ref}
LIB=${LIB:-/tmp/claude-0/reflib}
rm -rf "$REF"; mkdir -p "$REF" "$LIB"
git archive master | tar -x -C "$REF"
cd "$REF"
# drop optional dependencies (triangle, copula) that are not needed for the comparisons
sed -i '/^import("triangle")/d; /^importFrom("copula",/,/mvdc)/d; /mvrtriangle/d; /mvrcop/d' NAMESPACE
sed -i 's/^  triangle$//; s/^  copula,$//; s/  FLCore (>= 2.6.15),/  FLCore (>= 2.6.15)/' DESCRIPTION
rm -f R/FLModelSimMethods.R
sed -i "/'FLModelSimMethods.R'/d" DESCRIPTION
python3 - <<'PY'
import re
p = 'R/a4aGr-methods.R'
s = open(p).read()
blocks = re.split(r"\n(?=#' @title|setMethod|setGeneric)", s)
open(p, 'w').write('\n'.join(b for b in blocks
    if not re.search(r'set(Method|Generic)\("(mvrtriangle|mvrcop)"', b)))
PY
# pars2dim is no longer a generic in current FLCore
sed -i 's/^setMethod("pars2dim", "FLPar"/setGeneric("pars2dim", function(object, ...) standardGeneric("pars2dim"))\nsetMethod("pars2dim", "FLPar"/' R/utilities.R
cd ..
R CMD INSTALL --no-docs -l "$LIB" "$REF"
