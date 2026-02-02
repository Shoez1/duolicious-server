#!/bin/bash
# Pós-instalação: baixa modelos spaCy e NLTK necessários

set -e

if [ "${DUO_DISABLE_SPACY}" != "true" ]; then
    echo "Installing spaCy model..."
    python -m spacy download en_core_web_sm
fi

echo "Downloading NLTK data..."
python -c "
import nltk
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')
nltk.download('omw-1.4')
"

echo "Post-install complete!"
