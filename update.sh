#!/bin/bash
# Update.sh - Local Repository Index Compiler

dpkg-scanpackages -m debs > Packages
rm -f Packages.bz2 Packages.gz
bzip2 -k Packages
gzip -9fk Packages
echo "[V] Local repository indexes compiled successfully!"
