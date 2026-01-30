#!/usr/bin/env python3
import os
from service.api.decorators import app

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    if os.environ.get("DUO_ENV") == "prod":
        from database import initapi
        initapi.init()
        import gunicorn
    else:
        app.run(host="0.0.0.0", port=port, debug=True)
