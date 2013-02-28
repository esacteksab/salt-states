from .base import *

import os

DEBUG = True
TEMPLATE_DEBUG = DEBUG

DATABASES = {
        "default": {
            "ENGINE": '{{ pillar["sog-dbengine"] }}',
            "NAME": '{{ pillar["sog-dbname"] }}',
            "USER": '{{ pillar["sog-dbuser"] }}',
            "PASSWORD": '{{ pillar["sog-dbpassword"] }}',
            "HOST": '{{ pillar["sog-dbhost"] }}',
            "PORT": '{{ pillar["sog-dbport"] }}'
        }
    }


SITE_ID = 1  # set this to match your Sites setup

MEDIA_ROOT = os.path.join(PACKAGE_ROOT, "site_media", "media")
STATIC_ROOT = os.path.join(PACKAGE_ROOT, "site_media", "static")

ORPHANED_APPS_MEDIABASE_DIRS = {
    'web_site.apps.press': {
        'root': MEDIA_ROOT,
    }
}
FILE_UPLOAD_PERMISSIONS = 0640


LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "filters": {
        "require_debug_false": {
            "()": "django.utils.log.RequireDebugFalse"
        },
    },
    "formatters": {
        "simple": {
            "format": "%(levelname)s %(message)s"
        },
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "simple"
        },
        "mail_admins": {
            "level": "ERROR",
            "filters": ["require_debug_false"],
            "class": "django.utils.log.AdminEmailHandler"
        },
    },
    "root": {
        "handlers": ["console"],
        "level": "INFO",
    },
    "loggers": {
        "django.request": {
            "handlers": ["mail_admins"],
            "level": "ERROR",
            "propagate": True,
        },
    },
}

EMAIL_BACKEND = '{{ pillar["EMAIL_BACKEND"] }}'
EMAIL_HOST = '{{ pillar["EMAIL_HOST"] }}'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = '{{ pillar["EMAIL_HOST_USER"] }}'
EMAIL_HOST_PASSWORD = '{{ pillar["EMAIL_HOST_PASSWORD"] }}'
