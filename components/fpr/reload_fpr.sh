#!/bin/bash

set -eux

# get variables from .env file (note that $NABU must be defined at this point)
source "${NABU}"/.env

echo "Reloading the db"
pushd "${SQLITE_LOCATION}"
sqlite3 < "${NABU}"/components/fpr/create_fpr_table.sql
popd
