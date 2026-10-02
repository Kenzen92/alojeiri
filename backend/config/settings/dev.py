from .base import *

SECRET_KEY = SECRET_KEY or "dev-insecure-key-not-for-deployment"
DEBUG = True
ALLOWED_HOSTS = ["*"]
CORS_ALLOW_ALL_ORIGINS = True
STORAGES["staticfiles"] = {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"}
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"
