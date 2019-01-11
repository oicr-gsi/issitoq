[![Build Status](https://travis-ci.org/oicr-gsi/nabu.svg)](https://travis-ci.org/oicr-gsi/nabu)

> Nabu was the Babylonian and Assyrian god of scribes, literacy, and wisdom.

# Getting started

## Requirements
  * Node 4.5.0 or higher (developed on Node 8/9)
  * NPM (comes with Node)
  * PostgreSQL 9.5 or higher
  * SQLite3
  * Docker (for database migrations)

Checking for node:
```
node -v
```
[Instructions for updating NodeJS on Linux](https://codewithintent.com/how-to-install-update-and-remove-node-js-from-linux-or-ubuntu/)

## Installing modules
```
nabu$ npm install
```

SQLite3 may need to be built from source in order to comply with the version of Node on your system, as well as the system's architecture. If running `node app.js` or `nodejs app.js` shows errors with SQLite, run the following:
```
$ npm uninstall sqlite3
$ npm install sqlite3 --local --build-from-source
```

## Setting environment variables
Create a `.env` file and populate it. The `.env-example` file provides a template for this.
If a variable in this file is also set on the system, the file variable _will not_ overwrite the system variable.
You will have to decide what you want your `DB_NAME`, `DB_USER` and `DB_PW` to be. 
If you are running on your local machine, the `DB_HOST` will be `localhost`.
The `[...temporaryLocation...]` blocks can be anywhere on your computer.
The `[..projectLocation...]` is the location of the `nabu` directory on your file system, and `IGNORE_ADDRESS` can be left blank.

## Create a PostgreSQL database
Set up the same user and password as in your `.env` file
```
$ sudo -u postgres createdb ${DATABASE}
$ sudo -u postgres psql
# create user ${USER};
# alter role ${USER} with password '${PASSWORD}';
# grant all on database ${DATABASE} to ${USER};
# \q
```

## Migrating the PostgreSQL database using Docker
It is possible to manually apply database migration files (in the `sql` folder, named like `V#__.*.sql`), but using
Flyway allows database migrations to be applied in a prdictable order, and only once. To use Docker for database
migrations: Create a file in `conf/` called `flyway.conf` and add to it your database url, user, and password (similar
to the `.env` file. The `conf/example-flyway.conf` file provides a template for this.

After that initial setup, use the following to run the initial migration. Later, if any new updates require a database
migration, use the same command:
```
npm run fw:migrate
```

If the database needs to be wiped clean and reset, this can be done using the following:
```
npm run fw:clean
npm run fw:migrate
```
You may need to run `docker pull boxfuse/flyway:5.2.4` before running this command for the first time.
Note that `--network=host` in `fw:clean` and `fw:migrate` is particularly important if you're using `localhost` in `flyway.url`.

## Setting up the SQLite database (contains columns from the [File Provenance Report](https://github.com/oicr-gsi/provenance))
Nabu uses a SQLite database to store certain fields from the File Provenance Report. This SQLite database should be created in a directory outside of the Nabu directory.
```
$ mkdir /path/to/sqlite/dir
$ export SQLITE_LOCATION=/path/to/sqlite/dir
```

The [rsync_full_fpr.sh](components/fpr/rsync_full_fpr.sh) script will pull the latest version of the file provenance report, provided your environmental variables in `.env` are correctly set. If you are working with a local copy of the file provenance report, move or copy it to the `$SQLITE_LOCATION` directory you just created. The script can then be run without the line that begins with `rsync`. 

## Running the application
Start PostgreSQL using `pg_ctl start -l {DB LOG FILE LOCATION}` or any other method.
```
$ npm start
```

A Swagger/OpenAPI page will be available at `http://localhost:####/api-docs/index.html`. (The port is 3000 by default; if you want to run Nabu on another port, start it up using `PORT=#### npm start`.)

## Development
Run the linter before committing changes:
```
$ npm run lint
```
Linter settings are in .eslintrc.json .

## Testing

Create a file in `test/` called `flyway.conf`. The `test/example-flyway.conf` file provides a template for this. Use
these variables to create the test database below.

### Create a PostgreSQL database for the tests
```
$ psql postgres -U postgres

# create database ${TEST_DATABASE};
# create user ${TEST_USER};
# alter role ${TEST_USER} with password '${TEST_PASSWORD}';
# grant all on database ${TEST_DATABASE} to ${TEST_USER};
# \q
```

### Run the tests
Run tests using:
```
$ npm run test
```
