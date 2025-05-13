#!/bin/bash bashio

bashio::log.info "Starting..."

export GITEA_RUNNER_NAME=$(bashio::config 'runner_name')
export GITEA_INSTANCE_URL=$(bashio::config 'instance_url')
export GITEA_RUNNER_REGISTRATION_TOKEN=$(bashio::config 'registration_token')
export GITEA_RUNNER_LABELS=$(bashio::config 'labels')



bashio::log.info "Finished configuration. Going to start act runner..."

/opt/act/run.sh "$@"
