#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "dir: $SCRIPT_DIR"

chmod a+x "$SCRIPT_DIR/Test.AppDir/AppRun"
chmod a+x "$SCRIPT_DIR/Test.AppDir/usr/bin/test"