Salt States
-----------


Overview
========

* Installs Nginx/Postgresql/Memcache and necessary dependancies via Apt
* PIP installs uWSGI (for latest version)
* Creates upstart for uWSGI
* Uploads priv/pub keys
* Adds known hosts for git support
* Creates directories (declared in pillar files) in /usr/share/nginx/$site/
* Git clones into $site directories
* PIP installs from requirements.txt in an activated virtualenv
* Symlinks nginx and uwsgi files to enable/activate
* Deploys custom pg_hba.conf for Postgresql and restarts services
* Deploys custom memcache.conf for Memcached



`Salt`_ states

Located in /srv/salt


.. _Salt: http://salt.readthedocs.org/en/latest/index.html
