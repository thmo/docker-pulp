#!/bin/bash -e

PULP_API_BIND_PORT=${PULP_API_BIND_PORT:-24817}

GPG_KEY=/etc/gpg/gpg_key
GPG_HOME=/var/lib/pulp

echo "[INFO] Updating database schema"
pulpcore-manager migrate --noinput

if [[ -n $PULP_ADMIN_PASSWORD ]]; then
    echo "[INFO] Setting admin password"
    pulpcore-manager reset-admin-password --password ${PULP_ADMIN_PASSWORD}
fi

echo "[INFO] handling any needed checksum migration"
pulpcore-manager handle-artifact-checksums

echo "[INFO] Collecting static files"
pulpcore-manager collectstatic --noinput

if [[ -r "$GPG_KEY" ]]; then
echo "[INFO] Enabling Signing API"
# Import private key
gpg --import $GPG_KEY
# Export public key
gpg --export -a > /tmp/public.key
# Export key fingerprint
gpg /tmp/public.key 2>/dev/null | grep -E '[0-9A-Z]{40}' | awk '{print $1}' > /tmp/public.fpr

pulpcore-manager shell < /signing.py
fi

echo "[INFO] Starting API server"
gunicorn pulpcore.app.wsgi:application \
          --bind "0.0.0.0:${PULP_API_BIND_PORT}" \
          --access-logfile -
