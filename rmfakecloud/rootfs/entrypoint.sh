#!/bin/sh

. <(yq eval -o=shell '.' /data/options.json)
yq eval -o=shell '.' /data/options.json

export JWT_SECRET_KEY=$jwtSecretKey
export STORAGE_URL=$storageUrl
export RM_TRUST_PROXY=$rmTrustProxy

/rmfakecloud-docker $@
