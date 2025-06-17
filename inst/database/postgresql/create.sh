#!/usr/bin/env bash

# Create nemo database and tables based on schema
set -euo pipefail

createdb nemo
cat schema1.sql | psql nemo
