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



SUCCESS
=======

.. code:: shell

    [default] local:
    ----------
        State: - pkg
        Name:      python-dev
        Function:  installed
            Result:    True
            Comment:   Package python-dev is already installed
            Changes:
    ----------
        State: - pkg
        Name:      python-pip
        Function:  installed
            Result:    True
            Comment:   Package python-pip is already installed
            Changes:
    ----------
        State: - pip
        Name:      uwsgi
        Function:  installed
            Result:    True
            Comment:   Package already installed
            Changes:
    ----------
        State: - file
        Name:      /etc/init/uwsgi.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/init/uwsgi.conf is in the correct state
            Changes:
    ----------
        State: - file
        Name:      /etc/memcached.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/memcached.conf is in the correct state
            Changes:
    ----------
        State: - pkg
        Name:      nginx
        Function:  installed
            Result:    True
            Comment:   Package nginx is already installed
            Changes:
    ----------
        State: - file
        Name:      /etc/nginx/sites-available/project1.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/nginx/sites-available/project1.conf is in the correct state
            Changes:
    ----------
        State: - file
        Name:      /etc/nginx/sites-available/project2.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/nginx/sites-available/project2.conf updated
            Changes:   diff: ---
    +++
    @@ -1,13 +1,13 @@
     server {

    -   listen 80;
        #listen 443 default ssl;

        #ssl_certificate /etc/ssl/certs/### Need path to cert .pem
        #ssl_certificate_key /etc/ssl/private/###path to key .key

        # Make site accessible from http://localhost/
    -   server_name localhost
    +   server_name project2.com www.project2.com;
        location /admin {
            rewrite (.*) https://www.project2.com/$1 permanent;
        }

                       group: www-data
                       mode: 755
                       user: www-data

    ----------
        State: - file
        Name:      /etc/nginx/sites-enabled/default
        Function:  absent
            Result:    True
            Comment:   File /etc/nginx/sites-enabled/default is not present
            Changes:
    ----------
        State: - file
        Name:      /etc/nginx/sites-enabled/project1.conf
        Function:  symlink
            Result:    True
            Comment:   The symlink /etc/nginx/sites-enabled/project1.conf is present
            Changes:
    ----------
        State: - file
        Name:      /etc/nginx/sites-enabled/project2.conf
        Function:  symlink
            Result:    True
            Comment:   The symlink /etc/nginx/sites-enabled/project2.conf is present
            Changes:
    ----------
        State: - pkg
        Name:      postgresql-9.1
        Function:  installed
            Result:    True
            Comment:   Package postgresql-9.1 is already installed
            Changes:
    ----------
        State: - file
        Name:      /etc/postgresql/9.1/main/pg_hba.conf
        Function:  managed
            Result:    True
            Comment:   File /etc/postgresql/9.1/main/pg_hba.conf is in the correct state
            Changes:
    ----------
        State: - file
        Name:      /etc/salt/minion
        Function:  append
            Result:    True
            Comment:   Appended 0 lines
            Changes:
    ----------
        State: - file
        Name:      /etc/uwsgi/apps-available/web-site.ini
        Function:  managed
            Result:    True
            Comment:   File /etc/uwsgi/apps-available/project1.ini updated
            Changes:   diff: ---
    +++
    @@ -1,11 +1,9 @@
     [uwsgi]
     #Variables
    -base = /usr/share/nginx/www/project2/web_site
    -app = wsgi
    -#Generic Config
    -plugins = http,python
    -home = /usr/share/nginx/www/project2/venv
    +base = /usr/share/nginx/project1
    +home = /usr/share/nginx/project1/venv
     pythonpath = %(base)
     socket = /tmp/%n.sock
    -module = %(app)
    -logto = /var/log/uwsgi/%n.log+module = web_site.uwsgi
    +enable-threads = true
    +logto = /var/log/uwsgi/%n.log

                       group: www-data
                       mode: 755
                       user: www-data

    ----------
        State: - file
        Name:      /etc/uwsgi/apps-available/project2.ini
        Function:  managed
            Result:    True
            Comment:   File /etc/uwsgi/apps-available/project2.ini updated
            Changes:   diff: ---
    +++
    @@ -1,11 +1,9 @@
     [uwsgi]
     #Variables
    -base = /usr/share/nginx/www/project2/web_site
    -app = wsgi
    -#Generic Config
    -plugins = http,python
    -home = /usr/share/nginx/www/project2/venv
    +base = /usr/share/nginx/project2
    +home = /usr/share/nginx/project2/venv
     pythonpath = %(base)
     socket = /tmp/%n.sock
    -module = %(app)
    -logto = /var/log/uwsgi/%n.log+module = web_site.wsgi
    +enable-threads = true
    +logto = /var/log/uwsgi/%n.log

                       group: www-data
                       mode: 755
                       user: www-data

    ----------
        State: - file
        Name:      /etc/uwsgi/apps-enabled/project1.ini
        Function:  symlink
            Result:    True
            Comment:   The symlink /etc/uwsgi/apps-enabled/project1.ini is present
            Changes:
    ----------
        State: - file
        Name:      /etc/uwsgi/apps-enabled/project2.ini
        Function:  symlink
            Result:    True
            Comment:   The symlink /etc/uwsgi/apps-enabled/project2.ini is present
            Changes:
    ----------
        State: - file
        Name:      /root/.ssh/id_rsa.pub
        Function:  managed
            Result:    True
            Comment:   File /root/.ssh/id_rsa.pub updated
            Changes:   diff: New file
                       mode: 400

    ----------
        State: - file
        Name:      /root/.ssh/id_rsa
        Function:  managed
            Result:    True
            Comment:   File /root/.ssh/id_rsa updated
            Changes:   diff: New file
                       mode: 400

    ----------
        State: - file
        Name:      /root/.ssh/known_hosts
        Function:  managed
            Result:    True
            Comment:   File /root/.ssh/known_hosts updated
            Changes:   mode: 700

    ----------
        State: - file
        Name:      /usr/share/nginx/project2
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project2 updated
            Changes:   group: www-data
                       user: www-data
                       mode: 755

    ----------
        State: - file
        Name:      /usr/share/nginx/project2/web_site/conf
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project2/web_site/conf updated
            Changes:   group: www-data
                       /usr/share/nginx/project2/web_site/conf: New Dir
                       user: www-data

    ----------
        State: - file
        Name:      /usr/share/nginx/project1/web_site/conf/prod.py
        Function:  managed
            Result:    True
            Comment:   File /usr/share/nginx/project1/web_site/conf/prod.py updated
            Changes:   diff: New file

    ----------
        State: - file
        Name:      /usr/share/nginx/project1/web_site/conf
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project1/web_site/conf updated
            Changes:   group: www-data
                       user: www-data
                       mode: 755

    ----------
        State: - file
        Name:      /usr/share/nginx/project1/web_site
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project1/web_site updated
            Changes:   group: www-data
                       user: www-data

    ----------
        State: - file
        Name:      /usr/share/nginx/project1
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project1 updated
            Changes:   group: root
                       user: root
                       mode: 755

    ----------
        State: - file
        Name:      /usr/share/nginx/project2/web_site/conf/prod.py
        Function:  managed
            Result:    True
            Comment:   File /usr/share/nginx/project2/web_site/conf/prod.py updated
            Changes:   diff: New file

    ----------
        State: - file
        Name:      /usr/share/nginx/project2/web_site
        Function:  directory
            Result:    True
            Comment:   Directory /usr/share/nginx/project2/web_site updated
            Changes:   group: www-data
                       mode: 755
                       user: www-data

    ----------
        State: - file
        Name:      /usr/share/nginx/project2/web_site/wsgi.py
        Function:  managed
            Result:    True
            Comment:   File /usr/share/nginx/project2/web_site/wsgi.py updated
            Changes:   diff: New file
                       group: www-data
                       mode: 755
                       user: www-data

    ----------
        State: - file
        Name:      /var/log/uwsgi/app
        Function:  directory
            Result:    True
            Comment:   Directory /var/log/uwsgi/app is in the correct state
            Changes:
    ----------
        State: - file
        Name:      /var/log/uwsgi/emperor.log
        Function:  managed
            Result:    True
            Comment:   File /var/log/uwsgi/emperor.log is in the correct state
            Changes:
    ----------
        State: - file
        Name:      /var/log/uwsgi
        Function:  directory
            Result:    True
            Comment:   Directory /var/log/uwsgi is in the correct state
            Changes:
    ----------
        State: - pkg
        Name:      git
        Function:  installed
            Result:    True
            Comment:   Package git is already installed
            Changes:
    ----------
        State: - ssh_known_hosts
        Name:      bitbucket.org
        Function:  present
            Result:    True
            Comment:   bitbucket.org already exists in .ssh/known_hosts
            Changes:
    ----------
        State: - git
        Name:      git@bitbucket.org:esacteksab/project1-ws-web.git
        Function:  latest
            Result:    True
            Comment:   Repository git@bitbucket.org:esacteksab/project1-ws-web.git cloned to /usr/share/nginx/project1/
            Changes:   new: git@bitbucket.org:esacteksab/project1-ws-web.git
                       revision: b16f131cbdd7bea6d1a29f29bf155dc3f9d1fa77

    ----------
        State: - git
        Name:      git@bitbucket.org:esacteksab/project2-web.git
        Function:  latest
            Result:    True
            Comment:   Repository git@bitbucket.org:esacteksab/project2-web.git cloned to /usr/share/nginx/project2/
            Changes:   new: git@bitbucket.org:esacteksab/project2-web.git
                       revision: b820485323c971ebee68dd97655d7b07fb559d7b

    ----------
        State: - pkg
        Name:      libjpeg62-dev
        Function:  installed
            Result:    True
            Comment:   Package libjpeg62-dev is already installed
            Changes:
    ----------
        State: - pkg
        Name:      memcached
        Function:  installed
            Result:    True
            Comment:   Package memcached is already installed
            Changes:
    ----------
        State: - pkg
        Name:      postgresql-9.1-dbg
        Function:  installed
            Result:    True
            Comment:   Package postgresql-9.1-dbg is already installed
            Changes:
    ----------
        State: - pkg
        Name:      postgresql-server-dev-9.1
        Function:  installed
            Result:    True
            Comment:   Package postgresql-server-dev-9.1 is already installed
            Changes:
    ----------
        State: - pkg
        Name:      python-memcache
        Function:  installed
            Result:    True
            Comment:   Package python-memcache is already installed
            Changes:
    ----------
        State: - pkg
        Name:      python-virtualenv
        Function:  installed
            Result:    True
            Comment:   Package python-virtualenv is already installed
            Changes:
    ----------
        State: - pkg
        Name:      python2.7-dev
        Function:  installed
            Result:    True
            Comment:   Package python2.7-dev is already installed
            Changes:
    ----------
        State: - service
        Name:      postgresql
        Function:  running
            Result:    True
            Comment:   The service postgresql is already running
            Changes:
    ----------
        State: - postgres_user
        Name:      project1
        Function:  present
            Result:    True
            Comment:   User project1 is already present
    [default]
            Changes:
    ----------
        State: - postgres_database
        Name:      project1db
        Function:  present
            Result:    True
            Comment:   Database project1db is already present
            Changes:
    ----------
        State: - postgres_user
        Name:      project2
        Function:  present
            Result:    True
            Comment:   User project2 is already present
            Changes:
    ----------
        State: - postgres_database
        Name:      project2db
        Function:  present
            Result:    True
            Comment:   Database project2db is already present
            Changes:
    ----------
        State: - service
        Name:      memcached
        Function:  running
            Result:    True
            Comment:   The service memcached is already running
            Changes:
    ----------
        State: - service
        Name:      nginx
        Function:  running
            Result:    True
            Comment:   Service nginx is already enabled, and is running
            Changes:
    ----------
        State: - service
        Name:      uwsgi
        Function:  running
            Result:    True
            Comment:   Service uwsgi is already enabled, and is in the desired state
            Changes:
    ----------
        State: - virtualenv
        Name:      /usr/share/nginx/project1/venv
        Function:  manage
            Result:    True
            Comment:   Created new virtualenv
            Changes:   new: Python 2.7.3
                       packages: {'new': ['python-memcached==1.48',
             'pytz==2012c',
             'django-thumbs==0.4',
             'metron==1.0',
             'South==0.7.6',
             'django-appconf==0.5',
             'django-crispy-forms==1.1.4',
             'pinax-theme-bootstrap==2.0.4',
             'django-floppyforms==1.0',
             'pinax-theme-bootstrap-account==1.0b2',
             'py-bcrypt==0.2',
             'django-user-accounts==1.0b1',
             'psycopg2==2.4.5',
             'pinax-utils==1.0b1.dev3',
             'Pillow==1.7.7',
             'Django==1.4.3',
             'django-forms-bootstrap==2.0.3.post1'],
     'old': ''}

    ----------
        State: - virtualenv
        Name:      /usr/share/nginx/project2/venv
        Function:  manage
            Result:    True
            Comment:   Created new virtualenv
            Changes:   new: Python 2.7.3
                       packages: {'new': ['python-memcached==1.48',
             'django-thumbs==0.4',
             'South==0.7.5',
             'django-crispy-forms==1.1.4',
             'py-bcrypt==0.2',
             'psycopg2==2.4.5',
             'Pillow==1.7.7',
             'django-robots==0.8.1',
             'Django==1.4.3'],
     'old': ''}
