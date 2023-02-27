#!/command/with-contenv bash

function config {
  yq "$@" /data/options.json
}

export HOSTS=http://homeassistant.local,$(config '.hosts[].host' | head -c -1 | tr '\n' ',')

export PAPERLESS_ADMIN_USER=$(config '.admin.username')
export PAPERLESS_ADMIN_PASSWORD=$(config '.admin.password')
export PAPERLESS_FORCE_SCRIPT_NAME=$(curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" "http://supervisor/addons/${HOSTNAME/-/_}/info" | yq .data.ingress_entry)
export PAPERLESS_CSRF_TRUSTED_ORIGINS=$(config '.hosts[].host' | head -c -1 | tr '\n' ',')

export PAPERLESS_ALLOWED_HOSTS=$(echo -n $HOSTS | sed -E 's/https?:\/\///g')
export PAPERLESS_CSRF_TRUSTED_ORIGINS=$HOSTS
export PAPERLESS_CORS_ALLOWED_HOSTS=$HOSTS

# Ensure directories
CONSUMPTION_DIR="/share/$(config '.consumptionDir')"
mkdir -p "$CONSUMPTION_DIR"

DATA_DIRECTORY=/data/paperless
mkdir -p "$DATA_DIRECTORY"

export PAPERLESS_CONSUMPTION_DIR=$CONSUMPTION_DIR
export PAPERLESS_DATA_DIR=$DATA_DIRECTORY
export PAPERLESS_MEDIA_ROOT=$DATA_DIRECTORY

# Do nginx-related configuration
if [ $(config '.login') = "admin" ]
then
  export PAPERLESS_ENABLE_HTTP_REMOTE_USER=true
  envsubst '$PAPERLESS_ADMIN_USER'  < /etc/nginx/conf.d/ingress/templates/headers.remote-user.conf \
                                    > /etc/nginx/conf.d/ingress/headers.remote-user.conf || exit 1;
fi

export PAPERLESS_PORT=$(get-port paperless)
envsubst '$PAPERLESS_PORT'  < /etc/nginx/conf.d/default/templates/location.conf \
                            > /etc/nginx/conf.d/default/location.conf || exit 1;

# Reload nginx configuration
nginx -s reload

"/sbin/docker-entrypoint.sh" $@
