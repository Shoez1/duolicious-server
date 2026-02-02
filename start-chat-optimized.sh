#!/bin/bash
# Start do chat otimizado para Render free tier

set -e

if [ "${DUO_DISABLE_SPACY}" != "true" ]; then
    # Instala modelo spaCy se não existir
    if ! python -c "import spacy; spacy.load('en_core_web_sm')" 2>/dev/null; then
        echo "Installing spaCy model..."
        python -m spacy download en_core_web_sm
    fi
fi

echo "Starting Chat with memory optimizations..."
exec uvicorn service.chat:app \
    --host 0.0.0.0 \
    --port $PORT \
    --ws-max-size 10485760 \
    --workers 1 \
    --limit-concurrency 100 \
    --ws-ping-interval 20 \
    --ws-ping-timeout 20
