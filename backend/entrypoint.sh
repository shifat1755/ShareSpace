#!/bin/sh
set -e

echo "Waiting for database..."
while ! nc -z db 5432; do
  sleep 1
done

echo "Running Alembic migrations..."
if ! alembic upgrade head; then
  echo "Alembic migrations failed!" >&2
  exit 1
fi

echo "Starting app..."
exec uvicorn main:app --host 0.0.0.0 --port 8080
