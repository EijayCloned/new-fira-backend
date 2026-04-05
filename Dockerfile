FROM python:3.10

WORKDIR /app

# Install system dependencies for TensorFlow and build tools
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    libatlas-base-dev \
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
