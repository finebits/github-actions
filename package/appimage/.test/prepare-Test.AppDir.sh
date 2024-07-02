#!/bin/sh

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${0}")")"

echo "dir: $SCRIPT_DIR"

chmod a+x "$SCRIPT_DIR/Test.AppDir/AppRun"
chmod a+x "$SCRIPT_DIR/Test.AppDir/usr/bin/test"
