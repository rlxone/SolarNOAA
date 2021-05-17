#!/bin/bash

workspace_name=SolarNOAA.xcworkspace

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

cd "$(dirname "$0")/../"

test_scheme $workspace_name 'SolarNOAA-iOS-Tests' 'platform=iOS Simulator,name=iPhone 12'
test_scheme $workspace_name 'SolarNOAA-macOS-Tests' 'platform=macOS,arch=x86_64'
test_scheme $workspace_name 'SolarNOAA-watchOS-Tests' 'platform=watchOS Simulator,name=Apple Watch Series 5 - 40mm'
test_scheme $workspace_name 'SolarNOAA-tvOS-Tests' 'platform=tvOS Simulator,name=Apple TV 4K (2nd generation)'
