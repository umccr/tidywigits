#!/bin/bash

export DISABLE_AUTOBREW=1
R CMD INSTALL --build .

# Copy CLI to conda bin
mkdir -p ${PREFIX}/bin
cp ${SRC_DIR}/inst/cli/*.R ${PREFIX}/bin
chmod +x ${PREFIX}/bin/tidywigits.R
