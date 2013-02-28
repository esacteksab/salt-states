packages:
    pkg.installed:
        - names:
            - python2.7-dev
            - libjpeg62-dev
            - python-dev
            - git
            - python-virtualenv
            - python-pip


/etc/salt/minion:
    file.append:
        - text:
            - "postgres.user: 'postgres'"
            - "postgres.port: '5432'"
            - "postgres.host: 'localhost'"
            - "postgres.pass: ''"
            - "postgres.db: 'template0'"

