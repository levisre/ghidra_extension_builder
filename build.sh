#!/bin/bash

GHIDRA_RELEASE_PACKAGE_LINK=''
GHIDRA_EXTENSION_REPO_LINK=''
GHIDRA_ROOT_DIR=''
EXTENSION_ROOT_DIR=''

check_ghidra_dir() {
  if [ -z $GHIDRA_ROOT_DIR ]; then
    echo "No GHIDRA_ROOT_DIR set, seeking for current directory..."
    ghidra_run_file=$(find . -name "ghidraRun" -type f)
    if [ ! -z $ghidra_run_file ]; then
      echo "Found Ghidra at $ghidra_run_file"
      GHIDRA_ROOT_DIR=$(basename $(dirname $ghidra_run_file))
    fi
  else
    echo "Using GHIDRA_ROOT_DIR $GHIDRA_ROOT_DIR"
  fi
  #GHIDRA_ROOT_NAME=$(basename $GHIDRA_ROOT_DIR)
}

check_ghidra_dir

if [ -z $GHIDRA_ROOT_DIR ]; then
  if [ ! -z $GHIDRA_RELEASE_PACKAGE_LINK ]; then
    echo "Downloading Ghidra from $GHIDRA_RELEASE_PACKAGE_LINK"
    file_name=$(basename $GHIDRA_RELEASE_PACKAGE_LINK)

    if command -v wget &>/dev/null; then
      wget $GHIDRA_RELEASE_PACKAGE_LINK
    else
      curl -LO $GHIDRA_RELEASE_PACKAGE_LINK
    fi
    if [ $? -eq 0 ]; then # Download success
      if command -v unzip &>/dev/null; then
        unzip -q $file_name
        check_ghidra_dir
      fi
    else
      echo "Download failed"
      exit
    fi
  else
    echo "Ghidra not specified. Quit!"
    exit
  fi
fi

check_extension_dir() {
  if [ -z $EXTENSION_ROOT_DIR ]; then
    extension_file=$(find . -depth -maxdepth 2 -type f -name "Module.manifest")
    if [ ! -z $extension_file ]; then
      echo "Found Extension at $extension_file"
      EXTENSION_ROOT_DIR=$(basename $(dirname $extension_file))
    fi
  else
    echo "Using EXTENSION_ROOT_DIR $EXTENSION_ROOT_DIR"
  fi
  #GHIDRA_EXTENSION_NAME=$(basename $EXTENSION_ROOT_DIR)

}

check_extension_dir
if [ -z $EXTENSION_ROOT_DIR ]; then
  if [ ! -z $GHIDRA_EXTENSION_REPO_LINK ]; then
    echo "Downloading Ghidra Plugins from $GHIDRA_EXTENSION_REPO_LINK"
    if command -v git &>/dev/null; then
      git clone $GHIDRA_EXTENSION_REPO_LINK
      EXTENSION_ROOT_DIR=$(basename $GHIDRA_EXTENSION_REPO_LINK .git)
      check_extension_dir
    else
      echo "Must install git first"
      exit
    fi
  else
    echo "Extension not specified. Quit!"
    exit
  fi
fi

if command -v docker &>/dev/null; then
  if docker build --help 2>/dev/null | grep -q -- '--progress'; then
    DOCKER_BUILDKIT=1 docker build --build-arg GHIDRA_BIN_DIR=$GHIDRA_ROOT_DIR --build-arg GHIDRA_EXTENSION_REPO_DIR=$EXTENSION_ROOT_DIR . --output out #\
    #--build-arg GHIDRA_ROOT_NAME=$GHIDRA_ROOT_NAME --build-arg GHIDRA_EXTENSION_NAME=$GHIDRA_EXTENSION_NAME \
    #. --output out
  else
    echo "Docker buildkit not installed"
  fi
else
  echo "Must install docker first"
fi
