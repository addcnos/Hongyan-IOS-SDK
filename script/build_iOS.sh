#!/bin/bash -l
version=$1
message=$2

git clean -df "*"
# git checkout -- "*"


set +e
fastlane release version:"$version" message:"$message"

if [ $? -ne 0 ]; then
    echo "addcn:Compilation fails"
    exit 1
fi

echo "addcn:Compile successfully"
