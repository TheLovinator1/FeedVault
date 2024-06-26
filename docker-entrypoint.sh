#!/bin/sh

# Exit on error
set -e

# Debug
set -x

# 1. Collect static files
echo "Collect static files"
python manage.py collectstatic --noinput
echo "Collect static files done"

# 2. Apply database migrations
echo "Apply database migrations"
python manage.py migrate
echo "Apply database migrations done"

# 3. Create cache table
echo "Create cache table"
python manage.py createcachetable
echo "Create cache table done"

# https://docs.gunicorn.org/en/stable/design.html#how-many-workers
num_cores=$(nproc --all)
workers=$((2 * num_cores + 1))

# 4. Start server
echo "Starting server with $workers workers"
gunicorn --workers=$workers --bind=0.0.0.0:8000 feedvault.wsgi:application --log-level=info --access-logfile=- --error-logfile=- --forwarded-allow-ips="172.*,192.*" --proxy-allow-from="172.*,192.*"
echo "Bye, love you"
