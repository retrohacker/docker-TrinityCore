#!/usr/bin/env bash
set -x
print_section() {
  printf "\n# $1\n"
}

print_status () {
  printf "\n## $1\n\n"
}

DIR_INPUT="/input"
DIR_OUTPUT="/output"
DIR_TOOLS="/tools"

# Ensure directories exist
mkdir ${DIR_INPUT} ${DIR_OUTPUT}
cd ${DIR_INPUT}
print_section "Building Tools"
  print_status "mapextractor"
    ${DIR_TOOLS}/mapextractor
    cp -r dbc maps ${DIR_OUTPUT}
  print_status "vmaps"
    ${DIR_TOOLS}/vmap4extractor
    mkdir vmaps
    ${DIR_TOOLS}/vmap4assembler Buildings vmaps
    cp -r vmaps ${DIR_OUTPUT}
  print_status "mmaps"
    mkdir mmaps
   ${DIR_TOOLS}/mmaps_generator 
   cp -r mmaps ${DIR_OUTPUT}
  print_status "Fixing ownership of created files"
    find ${DIR_OUTPUT} -type d -exec chmod 777 {} \;
    find ${DIR_OUTPUT} -type f -exec chmod 666 {} \;
