#!/bin/sh

# Common Vairables
PROJECT_NAME=BMModuleKit
TARGET=BMModuleKit
CONFIGURATION=Release
BUILD_DIR=build
ENABLE_BITCODE=YES
BITCODE_GENERATION_MODE=bitcode
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

# Make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Include Shell Script
. ../dependencies.sh false

# Build framework
BUILD_FRAMEWORK universal

