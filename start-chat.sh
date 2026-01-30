#!/bin/bash
# Script de start do chat com env vars fallback

export DUO_ENV=${DUO_ENV:-prod}
export DUO_R2_AUDIO_BUCKET_NAME=${DUO_R2_AUDIO_BUCKET_NAME:-s3-mock-audio-bucket}
export DUO_R2_ACCT_ID=${DUO_R2_ACCT_ID:-dev}
export DUO_R2_ACCESS_KEY_ID=${DUO_R2_ACCESS_KEY_ID:-s3-mock-access-key-id}
export DUO_R2_ACCESS_KEY_SECRET=${DUO_R2_ACCESS_KEY_SECRET:-s3-mock-secret-access-key-secret}
export DUO_BOTO_ENDPOINT_URL=${DUO_BOTO_ENDPOINT_URL:-http://localhost:9090}

exec uvicorn service.chat:app --host 0.0.0.0 --port $PORT --ws-max-size 10485760 --workers 1
