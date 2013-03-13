include:
    - postgresql
    - nginx
    - uwsgi
    - ssh

{{ pillar["project2-path"] }}-djangouser:
    postgres_user.present:
        - name: {{ pillar['project2-dbuser'] }}
        - password: {{ pillar['project2-dbpassword'] }}
        - runas: postgres
        - require:
            - service: postgresql

{{ pillar["project2-path"] }}-djangodb:
    postgres_database.present:
        - name: {{ pillar['project2-dbname'] }}
        - encoding: UTF8
        - lc_ctype: en_US.UTF8
        - lc_collate: en_US.UTF8
        - template: template0
        - owner: {{ pillar['project2-dbuser'] }}
        - runas: postgres
        - require:
            - postgres_user: project2-djangouser

{{ pillar["project2-path"] }}-project-root:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['project2-path'] }}
        - user: root
        - group: root
        - recurse:
            - user
            - group
        - mode: 755
        - makedirs: true

{{ pillar["project2-path"] }}-project-git:
    git.latest:
        - name: {{ pillar['project2-git'] }}
        - rev: master
        - target: /usr/share/nginx/{{ pillar['project2-path'] }}/
        - force: true
        - require:
            - pkg: git
            - ssh_known_hosts: bitbucket.org


{{ pillar["project2-path"] }}-site-root:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['project2-path'] }}/web_site
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
        - mode: 755
        - require:
            - file: {{ pillar["project2-path"] }}-project-root

/usr/share/nginx/project2/venv:
    virtualenv.manage:
        - requirements: /usr/share/nginx/{{ pillar['project2-path'] }}/prod-requirements.txt
        - clear: false
        - require:
            - pkg: python-virtualenv
            - file: {{ pillar["project2-path"] }}-project-root

{{ pillar["project2-path"] }}-settings-dir:
    file:
        - directory
        - name: /usr/share/nginx/{{ pillar['project2-path'] }}/web_site/conf
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
        - mode: 755
        - makedirs: true
        - require:
            - file: {{ pillar["project2-path"] }}-project-root

{{ pillar["project2-path"] }}-prod-settings.py:
    file.managed:
        - name: /usr/share/nginx/{{ pillar['project2-path'] }}/web_site/conf/prod.py
        - source: salt://project2/prod.py
        - template: jinja
        - require:
            - file: {{ pillar["project2-path"] }}-settings-dir

{{ pillar["project2-path"] }}-uwsgi-app:
    file.managed:
        - name: /etc/uwsgi/apps-available/project2.ini
        - source: salt://project2/web-site.ini
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - pip: uwsgi 

{{ pillar["project2-path"] }}-enable-uwsgi-app:
    file.symlink:
        - name: /etc/uwsgi/apps-enabled/project2.ini
        - target: /etc/uwsgi/apps-available/project2.ini
        - force: false
        - makedirs: true
        - require:
            - file: /etc/uwsgi/apps-available/project2.ini

{{ pillar["project2-path"] }} nginx-conf:
    file.managed:
        - name: /etc/nginx/sites-available/project2.conf
        - source: salt://project2/project2.conf
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - pkg: nginx

{{ pillar["project2-path"] }}-enable-nginx-site:
    file.symlink:
        - name: /etc/nginx/sites-enabled/project2.conf
        - target: /etc/nginx/sites-available/project2.conf
        - force: false
        - require:
            - file: nginx-conf
