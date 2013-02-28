include:
    - postgresql
    - nginx
    - uwsgi
    - ssh

djangouser:
    postgres_user.present:
        - name: {{ pillar['dbuser'] }}
        - password: {{ pillar['dbpassword'] }}
        - runas: postgres
        - require:
            - service: postgresql

djangodb:
    postgres_database.present:
        - name: {{ pillar['dbname'] }}
        - encoding: UTF8
        - lc_ctype: en_US.UTF8
        - lc_collate: en_US.UTF8
        - template: template0
        - owner: {{ pillar['dbuser'] }}
        - runas: postgres
        - require:
            - postgres_user: djangouser

project-root:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['path'] }}
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
        - mode: 755
        - makedirs: true
        - require:
            - pkg: nginx

project-git:
    git.latest:
        - name: {{ pillar['git'] }}
        - rev: master
        - target: /usr/share/nginx/{{ pillar['path'] }}/
        - force: true
        - require:
            - pkg: git
            - ssh_known_hosts: bitbucket.org


site-root:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['path'] }}/web_site
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
        - mode: 755
        - require:
            - file: project-root

/usr/share/nginx/project1/venv:
    virtualenv.manage:
        - requirements: /usr/share/nginx/{{ pillar['path'] }}/requirements.txt
        - clear: false
        - require:
            - pkg: python-virtualenv
            - file: project-root

settings-dir:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['path'] }}/web_site/conf
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
        - mode: 755
        - makedirs: true
        - require:
            - file: project-root

prod-settings.py:
    file.managed:
        - name: /usr/share/nginx/{{ pillar['path'] }}/web_site/conf/prod.py
        - source: salt://project1/prod.py
        - template: jinja
        - require:
            - file: settings-dir

wsgi:
    file.managed:
        - name: /usr/share/nginx/{{ pillar['path'] }}/web_site/wsgi.py
        - source: salt://project1/wsgi.py
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - file: site-root


uwsgi-app:
    file.managed:
        - name: /etc/uwsgi/apps-available/project1.ini
        - source: salt://project1/web-site.ini
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - pip: uwsgi 

enable-uwsgi-app:
    file.symlink:
        - name: /etc/uwsgi/apps-enabled/project1.ini
        - target: /etc/uwsgi/apps-available/project1.ini
        - force: false
        - require:
            - file: uwsgi-app

nginx-conf:
    file.managed:
        - name: /etc/nginx/sites-available/project1.conf
        - source: salt://project1/project1.conf
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - pkg: nginx

enable-nginx-site:
    file.symlink:
        - name: /etc/nginx/sites-enabled/project1.conf
        - target: /etc/nginx/sites-available/project1.conf
        - force: false
        - require:
            - file: nginx-conf
