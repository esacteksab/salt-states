include:
    - reqs

/usr/lib/i386-linux-gnu/libjpeg.so:
    file:
        - symlink
        - target: /usr/lib/libjpeg.so
        - require:
            - pkg: libjpeg62-dev


/usr/lib/i386-linux-gnu/libfreetype.so:
    file:
        - symlink
        - target: /usr/lib/libfreetype.so
        - require:
            - pkg: libjpeg62-dev


/usr/lib/i386-linux-gnu/libfreetype.so.6:
    file:
        - symlink
        - target: /usr/lib/libfreetype.so.6
        - require:
            - pkg: libjpeg62-dev


/usr/lib/i386-linux-gnu/libz.so:
    file:
        - symlink
        - target: /usr/lib/libz.so
        - require:
            - pkg: libjpeg62-dev

