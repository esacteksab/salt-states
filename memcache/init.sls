memcached:
    pkg.installed:
        - name: memcached
    file.managed:
        - name: /etc/memcached.conf
        - source: salt://memcache/memcached.conf
    service.running:
        - enabled: true
        - watch: 
            - file: /etc/memcached.conf


python-memcache:
    pkg.installed:
        - name: python-memcache
    require:
        - pkg: memcached
