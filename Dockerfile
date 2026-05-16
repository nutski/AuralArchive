FROM python:3.12-slim

# Prevent Python from writing .pyc files and force logs to stdout immediately
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Default Unraid-friendly environment variables
ENV PUID=99
ENV PGID=100
ENV UMASK=002
ENV APP_PORT=8765

# Install system packages likely needed for audio/download/conversion apps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    curl \
    ca-certificates \
    bash \
    gosu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first for better Docker cache usage
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY . .

# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh

# Create common config/data folders
RUN mkdir -p /config /data /downloads /books

EXPOSE 5000

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["python", "app.py"]
