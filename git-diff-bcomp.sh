#!/bin/sh
# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode
/opt/bcompare/bin/bcompare "$2" "$5" | cat
