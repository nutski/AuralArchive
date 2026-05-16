FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV UMASK=002
ENV APP_PORT=8765

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    curl \
    ca-certificates \
    bash \
    gosu \
    git \
    build-essential \
    gcc \
    g++ \
    python3-dev \
    pkg-config \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    rustc \
    cargo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir --prefer-binary -r requirements.txt

COPY . .

RUN chmod +x /app/entrypoint.sh \
    && mkdir -p /config /data /downloads /books

EXPOSE 8765

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["python", "app.py"]
