# Étape 1 : Construction (l'usine)
FROM python:3.14-slim AS construction

RUN python -m venv /opt/venv
COPY requirements.txt .
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Étape 2 : Image finale (le plat servi)
FROM python:3.14-slim

RUN useradd -u 10001 appli
COPY --from=construction /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY app/ ./app/

USER 10001:10001

EXPOSE 8000

# HEALTHCHECK optimisé avec timeout et sans exit 1 inutile
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"]

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
