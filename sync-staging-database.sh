#!/bin/bash

PRODUCTION_REMOTE="production"
STAGING_REMOTE="staging"
DATABASE_NAME="SHARED_DATABASE"

latest_backup()
{
    heroku pgbackups -r $PRODUCTION_REMOTE | tail -n 1 | cut -f 1 -d ' '
}

## Main program

set -x

URL="$(heroku pgbackups:url $(latest_backup) -r $PRODUCTION_REMOTE)"
heroku pgbackups:restore "$DATABASE_NAME" "$URL" -r "$STAGING_REMOTE"
