#!/usr/bin/env bash
# Espera a que la base de datos esté lista
while ! nc -z db 3306; do
  echo "Esperando a MySQL..."
  sleep 2
done

# Aplica migraciones y crea superusuario si no existe
python manage.py migrate --noinput

# (Opcional) crea un superusuario por defecto
# echo "from django.contrib.auth import get_user_model; \
# User = get_user_model(); \
# User.objects.filter(username='admin').exists() or \
# User.objects.create_superuser('admin','admin@example.com','rootpass')" \
# | python manage.py shell

# Arranca Django
python manage.py runserver 0.0.0.0:8000
