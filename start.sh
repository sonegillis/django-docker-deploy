#!/bin/bash
cd /home/apps/Cargo-Tracking/
python3 manage.py collectstatic
ls
/usr/bin/gunicorn --workers 3 --bind unix:/home/apps/Cargo-Tracking/cargotracking.sock cargotracking.wsgi:application --daemon
service nginx status
service mysql status
service nginx start
service mysql start
service nginx status
service mysql status
/usr/bin/gunicorn --workers 3 --bind unix:/home/apps/Cargo-Tracking/cargotracking.sock cargotracking.wsgi:application