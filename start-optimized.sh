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

# Baixa dados NLTK se necessário
python -c "
import nltk
try:
    nltk.data.find('tokenizers/punkt')
except LookupError:
    nltk.download('punkt')
try:
    nltk.data.find('corpora/stopwords')
except LookupError:
    nltk.download('stopwords')
try:
    nltk.data.find('corpora/wordnet')
except LookupError:
    nltk.download('wordnet')
try:
    nltk.data.find('corpora/omw-1.4')
except LookupError:
    nltk.download('omw-1.4')
"

echo "Starting API with memory optimizations..."
exec gunicorn service.api:app \
    --bind 0.0.0.0:$PORT \
    --timeout 0 \
    --workers 1 \
    --max-requests 1000 \
    --max-requests-jitter 100 \
    --worker-class sync \
    --limit-request-line 4094
