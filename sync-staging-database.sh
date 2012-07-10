#!/bin/bash

PRODUCTION_REMOTE="production"
STAGING_REMOTE="staging"
DATABASE_NAME="SHARED_DATABASE"

## Functions

reset_staging_database()
{
    heroku pg:reset $DATABASE_NAME -r $STAGING_REMOTE
}

latest_backup()
{
    heroku pgbackups -r $PRODUCTION_REMOTE | tail -n 1 | cut -f 1 -d ' '
}

latest_backup_url()
{
    heroku pgbackups:url $(latest_backup) -r $PRODUCTION_REMOTE
}

restore_production_to_staging()
{
    local url="$(latest_backup_url)"
    heroku pgbackups:restore $DATABASE_NAME "$url" -r $STAGING_REMOTE
}

## Main program

set -x

reset_staging_database
restore_production_to_staging
