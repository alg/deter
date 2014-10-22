DETER
=====

Requirements
------------

* Ruby version 2.1.3
* Redis 2.6.16 or newer

Configuration
-------------

* Review configuration in config.yml
* Update database.yml
* Initialize database

    $ bin/rake db:setup

Testing
-------

    $ bin/rake test:all

Running
-------

    $ foreman start

Deploying
---------

* Review deploy.yml
* Copy config/deploy/production.rb.sample to config/deploy/production.rb
  and update user/server
* Run deployment:

    $ cap production deploy
