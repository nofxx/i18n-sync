i18n Sync!
==========

Syncs all locales/languages yml/rb files *keys* based on a "master" one.


Install
-------

    gem install i18n-sync


## Use

Synchonize all files (default to master :en)

    i18s

Or specify a master:

    i18s path/to/master/app.pt.yml

All other yml should be located on the same folder as the "master".
This command syncs all config/locale/app.*.yml files keys
using 'app.pt.yml' as the master.


# New Files

    i18s config/locales/app.en.yml pt es it


This creates 'app.pt.yml', 'app.es.yml'....


# Add Key

    i18s add some.very.nested.key Value prefix

Adds the new key on the file and every other translation.


# Del Key

    i18s del some.nested.key prefix

Deletes that key from files with prefix


# Rails default path

Defaults to "config/locales"


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


Copyright
---------

Copyright (c) 2010 Marcos Piccinini. See LICENSE for details.
