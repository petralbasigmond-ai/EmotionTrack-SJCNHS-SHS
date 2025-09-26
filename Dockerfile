# syntax=docker/dockerfile:1

FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates libpq5 \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --yes
ENV PATH="/root/.local/bin:${PATH}"

# Install dependencies using uv and lockfile
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --system

# Copy application code
COPY . .

# Expose a default port (Railway supplies PORT at runtime)
EXPOSE 8000

# Start Gunicorn, binding to Railway's PORT env var (fallback to 8000 for local testing)
CMD ["sh", "-c", "gunicorn -w 3 -k gthread -b 0.0.0.0:${PORT:-8000} main:app"]