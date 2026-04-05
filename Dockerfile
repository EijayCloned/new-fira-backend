FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies (if needed for TensorFlow/image processing)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Environment variables for Python and production
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:${PORT:-8000}/', timeout=5)" || exit 1

# Expose port 8000 (Render's default if $PORT not set)
EXPOSE 8000

# Start with Gunicorn (production WSGI server)
# Bind to 0.0.0.0:$PORT - Render injects $PORT at runtime
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120 --access-logfile - --error-logfile - app:app"]
