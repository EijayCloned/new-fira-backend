# Use official TensorFlow image with CPU support (has everything pre-built)
FROM tensorflow/tensorflow:2.19.0

WORKDIR /app

# Install only system dependencies not included in tensorflow image
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Force reinstall to override system-installed packages
RUN pip install --no-cache-dir --break-system-packages --ignore-installed -r requirements.txt

COPY . .

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

EXPOSE $PORT

# Run with Gunicorn (production server)
CMD ["gunicorn", "--bind", "0.0.0.0:${PORT:-8080}", "--workers", "1", "--timeout", "120", "--access-logfile", "-", "app:app"]
