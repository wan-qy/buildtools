#!/usr/bin/env bash

__PROJECT_DIR=$1
__DOTNET_CMD=$2
__TOOLRUNTIME_DIR=$3
__TOOLS_DIR=$(cd "$(dirname "$0")"; pwd -P)

__BUILDERRORLEVEL=0

if [ ! -d "$__PROJECT_DIR" ]; then
   echo "ERROR: Cannot find project root path at '$__PROJECT_DIR'. Please pass in the source directory as the 1st parameter."
   exit 1
fi

if [ ! -d "$__TOOLS_DIR" ]; then
   echo "ERROR: Cannot find tools path at '$__TOOLS_DIR'. Please pass in the tools directory as the 2nd parameter."
   exit 1
fi

if [ ! -e "$__DOTNET_CMD" ]; then
   echo "ERROR: Cannot find dotnet.exe at path '$__DOTNET_CMD'. Please pass in the path to dotnet.exe as the 3rd parameter."
   exit 1
fi

OSName=$(uname -s)
case $OSName in
    Darwin)
        __PUBLISH_RID=osx.10.10-x64
        ;;

    Linux)
        __PUBLISH_RID=ubuntu.14.04-x64
        ;;

    *)
        echo "Unsupported OS $OSName detected. Downloading ubuntu-x64 tools"
        __PUBLISH_RID=ubuntu.14.04-x64
        ;;
esac

cp -R $__TOOLS_DIR/* $__TOOLRUNTIME_DIR
chmod a+x $__TOOLRUNTIME_DIR/corerun

cd $__TOOLS_DIR/tool-runtime/
$__DOTNET_CMD restore --source https://www.myget.org/F/dotnet-core/ --source https://www.myget.org/F/dotnet-buildtools/ --source https://www.nuget.org/api/v2/
$__DOTNET_CMD publish -f dnxcore50 -r ${__PUBLISH_RID} -o $__TOOLRUNTIME_DIR

exit $__BUILDERRORLEVEL