#!/bin/bash

BRANCH="${BRANCH:-master}"


# Functions

usage()
{
    echo "Usage: [BRANCH=master] $(basename $0) <remote> [no-migrations]" >&2
    echo >&2
    echo "        remote         Name of git remote for Heroku app" >&2
    echo "        no-migrations  Deploy without running migrations" >&2
    echo >&2
    exit 1
}

has_remote()
{
    git remote | grep -qs "$REMOTE"
}

show_undeployed_changes()
{
    git fetch $REMOTE
    local range="$REMOTE/master..$BRANCH"
    local commits=$(git log --reverse --pretty=format:'%h | %cr: %s (%an)' $range)
    
    if [ -z "$commits" ]; then
        echo "Nothing to deploy"
        exit 1
    else
        echo -e "Undeployed commits:\n"
        echo -e "$commits"
        echo -e -n "\nPress enter to continue... "
        read
    fi
}

backup_database()
{
    if [ "$REMOTE" = "production" ]; then
        bundle exec heroku pgbackups:capture --expire --remote $REMOTE
    fi
}

deploy_changes()
{
    if [ "$REMOTE" = "production" ]; then
        git push $REMOTE $BRANCH:master
    else
        git push -f $REMOTE $BRANCH:master
    fi
}

migrate_database()
{
    if running_migrations; then
        bundle exec heroku maintenance:on --remote $REMOTE
        bundle exec heroku run rake db:migrate --remote $REMOTE
        bundle exec heroku maintenance:off --remote $REMOTE
    fi
}

running_migrations()
{
    [ "$COMMAND" != "no-migrations" ]
}


# Main program

set -e

REMOTE="$1"
COMMAND="$2"

[ -n "$DEBUG" ] && set -x
[ -z "$REMOTE" ] && usage

[ ! has_remote ] && usage

show_undeployed_changes
backup_database
deploy_changes
migrate_database
