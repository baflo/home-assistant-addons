#!/bin/bash bashio

export GITEA_RUNNER_NAME = $(bashio::config 'runner_name')
export GITEA_INSTANCE_URL = $(bashio::config 'instance_url')
export GITEA_RUNNER_REGISTRATION_TOKEN = $(bashio::config 'registration_token')
export GITEA_RUNNER_LABELS = $(bashio::config 'labels')

/opt/act/run.sh "$@"
