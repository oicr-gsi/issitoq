#!/bin/bash

# since we need to mount all the migrations in a single directory, the "regular" migrations need to be
# copied into the `test` folder, then deleted after.
cp sql/V*.sql test/migrations/

docker run --rm -v $(pwd)/test:/flyway/conf -v $(pwd)/test/migrations:/flyway/sql --network=host boxfuse/flyway clean && \
docker run --rm -v $(pwd)/test:/flyway/conf -v $(pwd)/test/migrations:/flyway/sql --network=host boxfuse/flyway migrate

# delete migrations that don't begin with V9* (test data)
find test/migrations/ -type f ! -name 'V9*.sql' -delete

# set up the test SQLite db
cd test && \
  sqlite3 fpr.db < create_test_fpr.sql && \
  cd -
