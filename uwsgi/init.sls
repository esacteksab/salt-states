include: 
    - reqs
    - nginx

uwsgi: 
    pip.installed:
        - pkgs: 
            uwsgi
        - require:
            - pkg: python-dev
            - pkg: python-pip

uwsgi-service:
    service.running:
        - enable: True
        - name: uwsgi
        - require:
            - file: /etc/init/uwsgi.conf


/etc/init/uwsgi.conf:
    file.managed:
        - source: salt://uwsgi/uwsgi.conf
        - temlpate: jinja
        - require:
            - pip: uwsgi


/var/log/uwsgi:
    file:
        - directory
        - user: www-data
        - group: www-data
        - makedirs: true
        - require: 
            - pip: uwsgi
            - pkg: nginx

/var/log/uwsgi/app:
    file:
        - directory
        - user: www-data
        - group: www-data
        - makedirs: true
        - require:
            - pip: uwsgi
            - pkg: nginx

/var/log/uwsgi/emperor.log:
    file:
        - managed
        - user: www-data
        - group: www-data
        - require:
            - pip: uwsgi
            - pkg: nginx

