#!/command/with-contenv bash

function config {
  yq "$@" /data/options.json
}

function strip-last-char {
  cat | head -c -1
}

export HOSTS=http://localhost,http://homeassistant.local,$(config '.hosts[].host' | strip-last-char | tr '\n' ','),$(ip addr show | grep -oP "inet \K[0-9.]+" | sed 's/^/http:\/\//' | tr '\n' ',' | sed 's/,$//')

export PAPERLESS_ADMIN_USER=$(config '.admin.username')
export PAPERLESS_ADMIN_PASSWORD=$(config '.admin.password')
export PAPERLESS_FORCE_SCRIPT_NAME=$(curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" "http://supervisor/addons/${HOSTNAME/-/_}/info" | yq .data.ingress_entry)
export PAPERLESS_CSRF_TRUSTED_ORIGINS=$(config '.hosts[].host' | strip-last-char | tr '\n' ',')

export PAPERLESS_CONSUMER_RECURSIVE=$(config '.consumption.recursively')
export PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS=$(config '.consumption.subdirsAsTags')

export PAPERLESS_ALLOWED_HOSTS=$(echo -n $HOSTS | sed -E 's/https?:\/\///g')
export PAPERLESS_CSRF_TRUSTED_ORIGINS=$HOSTS
export PAPERLESS_CORS_ALLOWED_HOSTS=$HOSTS

export PAPERLESS_TIKA_ENABLED=$(config '.tika_enabled')
export PAPERLESS_TIKA_ENDPOINT=$(config '.tika_endpoint')
export PAPERLESS_TIKA_GOTENBERG_ENDPOINT=$(config '.tika_gotenberg_endpoint')

# Ensure directories
CONSUMPTION_DIR="/share/$(config '.consumption.dir')"
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
  envsubst '$PAPERLESS_ADMIN_USER'  < /etc/nginx/conf.d/ingress/templates/headers.remote-user-admin.conf \
                                    > /etc/nginx/conf.d/ingress/headers.remote-user.conf || exit 1;
elif [ $(config '.login') = "auto" ]
then
  export PAPERLESS_ENABLE_HTTP_REMOTE_USER=true
  cp /etc/nginx/conf.d/ingress/templates/headers.remote-user-from-ingress.conf \
                                      /etc/nginx/conf.d/ingress/headers.remote-user.conf;
fi

export PAPERLESS_BIND_ADDR=127.0.0.1
export PAPERLESS_PORT=8888
for target in default ingress; do
  envsubst '$PAPERLESS_PORT'  < "/etc/nginx/conf.d/$target/templates/location.conf" \
                              > "/etc/nginx/conf.d/$target/location.conf" || exit 1;
done

# OCR config
export PAPERLESS_OCR_LANGUAGE=$(config '.ocr_langs[]' | strip-last-char | tr '\n' '+')
export PAPERLESS_OCR_LANGUAGES=$(config '.ocr_langs[]' | strip-last-char | tr '\n' ' ')

# Docker specific
export PAPERLESS_WEBSERVER_WORKERS=$(config '.web_workers')

# Reload nginx configuration
nginx -s reload

env > /env.sh

"/sbin/docker-entrypoint.sh" $@
