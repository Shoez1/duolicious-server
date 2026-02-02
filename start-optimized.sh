#!/bin/bash
# Start otimizado para Render free tier (512MB)

set -e

if [ "${DUO_DISABLE_SPACY}" != "true" ]; then
    # Instala modelo spaCy se não existir
    if ! python -c "import spacy; spacy.load('en_core_web_sm')" 2>/dev/null; then
        echo "Installing spaCy model..."
        python -m spacy download en_core_web_sm
    fi
fi

echo "Starting API with memory optimizations..."
exec gunicorn service.api:app \
    --bind 0.0.0.0:$PORT \
    --timeout 0 \
    --workers 1 \
    --max-requests 1000 \
    --max-requests-jitter 100 \
    --worker-class sync \
    --limit-request-line 4094
