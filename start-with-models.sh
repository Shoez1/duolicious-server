#!/bin/bash
# Inicia a API garantindo que os modelos spaCy/NLK estejam instalados

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

echo "Starting API..."
exec gunicorn service.api:app --bind 0.0.0.0:$PORT --timeout 0
