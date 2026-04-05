FROM python:3.10-slim

WORKDIR /app

# Install system dependencies including libatlas for TensorFlow
RUN apt-get update --fix-missing && apt-get install -y \
    gcc \
    g++ \
    curl \
    libatlas-base-dev \
    python3-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

EXPOSE $PORT

# Run with Gunicorn (production server)
CMD ["gunicorn", "--bind", "0.0.0.0:${PORT:-8080}", "--workers", "1", "--timeout", "120", "--access-logfile", "-", "app:app"]
