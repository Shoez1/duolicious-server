#!/bin/bash
# Script de start seguro que define env vars com fallbacks

export DUO_ENV=${DUO_ENV:-prod}
export DUO_R2_AUDIO_BUCKET_NAME=${DUO_R2_AUDIO_BUCKET_NAME:-s3-mock-audio-bucket}
export DUO_R2_ACCT_ID=${DUO_R2_ACCT_ID:-dev}
export DUO_R2_ACCESS_KEY_ID=${DUO_R2_ACCESS_KEY_ID:-s3-mock-access-key-id}
export DUO_R2_ACCESS_KEY_SECRET=${DUO_R2_ACCESS_KEY_SECRET:-s3-mock-secret-access-key-secret}
export DUO_BOTO_ENDPOINT_URL=${DUO_BOTO_ENDPOINT_URL:-http://localhost:9090}
export DUO_CORS_ORIGINS=${DUO_CORS_ORIGINS:-*}

exec gunicorn service.api:app --bind 0.0.0.0:$PORT --timeout 0
