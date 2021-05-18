#!/bin/bash

workspace_name=SolarNOAA.xcworkspace

function build_scheme()
{
  workspace=$1
  scheme=$2
  destination=$3
  
  xcodebuild \
    -workspace "$workspace" \
    -scheme "$scheme" \
    -destination "$destination" \
    clean build
  
  if [ $? -ne 0 ] 
  then
    exit 1
  fi
}

cd "$(dirname "$0")/../"

build_scheme $workspace_name 'iOS Example' 'platform=iOS Simulator,name=iPhone 12'
build_scheme $workspace_name 'macOS Example' 'platform=macOS,arch=x86_64'
build_scheme $workspace_name 'tvOS Example' 'platform=tvOS Simulator,name=Apple TV'
build_scheme $workspace_name 'watchOS Example WatchKit App' 'platform=watchOS Simulator,name=Apple Watch Series 5 - 40mm'