#!/bin/bash
# Start do chat otimizado para Render free tier

set -e

# Instala modelo spaCy se não existir
if ! python -c "import spacy; spacy.load('en_core_web_sm')" 2>/dev/null; then
    echo "Installing spaCy model..."
    python -m spacy download en_core_web_sm
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

echo "Starting Chat with memory optimizations..."
exec uvicorn service.chat:app \
    --host 0.0.0.0 \
    --port $PORT \
    --ws-max-size 10485760 \
    --workers 1 \
    --limit-concurrency 100 \
    --ws-ping-interval 20 \
    --ws-ping-timeout 20
