i18n Sync!
==========

Syncs all locales/languages yml/rb files *keys* based on a "master" one.



Install
-------

    gem install i18n_sync


Use
===


    i18s path/to/master/file.lang.yml


All other yml should be located on the same folder as the "master".

Example:


    i18s config/locales/app.en.yml

This command syncs all config/locale/app.*.yml files keys
using 'app.en.yml' as the template.


Create New Files
----------------

    i18s config/locales/app.en.yml pt es it


This creates 'app.pt.yml', 'app.es.yml'....



Add Key
-------

    i18s add some.very.nested.key Value path/to/file

Adds the new key on the file and every other translation.



Full Sync
---------

    i18s path/to/directory

Syncronizes the entire directory.



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
