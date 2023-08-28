#!/bin/bash

usage(){
    cat <<EOU
    Installs Davinci Resolve 18.5.1
    on Void Linux / dwm desktop.
    Must run with root rights.

    $0 <path/to/unzipped/davinci/installer>

    Prerequisite: dependencies are installed.

EOU
}

DAVINCI_INSTALLER="$1"
if [ ! -x "$DAVINCI_INSTALLER" ]; then
    echo "Expecting path to Da Vinci installer"
    usage
fi

$DAVINCI_INSTALLER

# These point to outdated libs,
# but the newer ones are already installed.
# So, just move them out of the way.
mkdir /opt/resolve/libs/_disabled
mv libgio-2.0.so* _disabled/
mv libglib-2.0.so* _disabled/
mv libgmodule-2.0.so* _disabled/
mv libgobject-2.0.so* _disabled/


