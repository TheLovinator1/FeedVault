"""WSGI config for FeedVault project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/howto/deployment/wsgi/
"""

import os

from django.core.handlers.wsgi import WSGIHandler
from django.core.wsgi import get_wsgi_application

os.environ.setdefault(key="DJANGO_SETTINGS_MODULE", value="feedvault.settings")

application: WSGIHandler = get_wsgi_application()
