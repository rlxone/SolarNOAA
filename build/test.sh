#!/bin/bash

# GLOBAL VARIABLES

workspace_name=SolarNOAA.xcworkspace

# FUNCTIONS

function test_scheme()
{
  workspace=$1
  scheme=$2
  destination=$3
  
  xcodebuild \
    -workspace "$workspace" \
    -scheme "$scheme" \
    -destination "$destination" \
    test
  
  if [ $? -ne 0 ] 
  then
    exit 1
  fi
}

function version_greater_or_equal() {
  printf '%s\n%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

function get_xcode_version()
{
  echo $(xcodebuild -version | sed -En 's/Xcode[[:space:]]+([0-9\.]*)/\1/p')
}

# ACTION

cd "$(dirname "$0")/../"

test_scheme $workspace_name 'SolarNOAA-iOS-Tests' 'platform=iOS Simulator,name=iPhone 12'
test_scheme $workspace_name 'SolarNOAA-macOS-Tests' 'platform=macOS,arch=x86_64'
test_scheme $workspace_name 'SolarNOAA-tvOS-Tests' 'platform=tvOS Simulator,name=Apple TV'

# Xcode 12.5 and greater can test watchOS
if version_greater_or_equal $(get_xcode_version) 12.5
then
  test_scheme $workspace_name 'SolarNOAA-watchOS-Tests' 'platform=watchOS Simulator,name=Apple Watch Series 5 - 40mm'
fi