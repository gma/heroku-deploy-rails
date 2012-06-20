heroku-deploy-rails
===================

heroku-deploy-rails is a short shell script that I use to deploy my Rails
projects to Heroku.

Installation
------------

Copy `deploy.sh` into your Rails project, and commit it. Then rename the
git remote for your production app to "production":

    $ git remote rename heroku production

The reason you need to do this is that `deploy.sh` will only make
backups of your Postgres database when deploying to a remote called
"production". If you'd rather call your remote something else, just edit
the script.

You'll also want to [enable backups][] on your app, if you haven't
already.

    $ heroku addons:add pgbackups:auto-month

If you haven't already added a second heroku app to serve as your
staging environment, I'd heartily recommend it (but it is optional as
far as `deploy.sh` goes).

[enable backups]: https://devcenter.heroku.com/articles/pgbackups

Why not just run git push?
--------------------------

It automates two things for me:

1. It takes a backup of the production database before the deployment.
2. It runs migrations after the code has been pushed.

It also shows you which commits you're about to deploy, and gives you
the option to confirm/abort.

Why not use [insert name of existing project here]?
---------------------------------------------------

All the Heroku deployment tools that I've seen to date are written in
Ruby. There's nothing wrong with writing jobs that are best handled by a
shell script in Ruby, unless you want to hang around while it starts up
and want to trawl through a load of unnecessary boilerplate to discover
what's really going on.

Some of them are written in Rake. WTF? That's not what Rake is for; it's
for resolving dependencies. It's a build tool. Yes, that's right - the
clue is in the name - Rake is like Make, which explains why it doesn't
support command line arguments or switches. But whatever. If you like
smashing yourself in the face with a blunt instrument, be my guest. ;-)

Shell scripting. You've got to love it. Mr Tomayko knows what he's
about, so if you don't believe me, [believe him][talk] instead.

[talk]: http://shellhaters.heroku.com/
