#!/bin/bash

echo "deb_repo=$deb_repo"
echo "packages=$packages"

PACKAGE=$packages
# Strip leading/trailing quotes if present.
deb_repo=`echo $deb_repo | sed 's/^"\(.*\)"$/\1/'`

# Support space-separated list of packages to install.
# Strip leading/trailing quotes if present.
packages=`echo $packages | sed 's/^"\(.*\)"$/\1/'`

# Only add the new source repository if deb_repo is set.
if [[ "$deb_repo" != "" ]]; then

# If .repo is on the end then we assume it is an rpm, otherwise assume deb.
if [[ "$deb_repo" == *".repo" ]]
  then
    cd /etc/yum.repos.d && sudo wget $deb_repo
    CMD="sudo yum install -y $packages"
    eval $CMD
  else
    echo "deb $deb_repo" | sudo tee /etc/apt/sources.list.d/spinnaker.list > /dev/null
    sudo apt-get update
    sudo apt-get install --force-yes -y $packages
  fi
fi
