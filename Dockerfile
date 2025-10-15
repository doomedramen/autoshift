# Use a minimal Python 3.12 base image
FROM python:3.12-alpine3.21

# Prevent Python from writing .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Default environment variables (from env.default)
ENV SHIFT_DATA_DIR=/data \
    SHIFT_COOKIE_FILE=/data/.cookies.save \
    SHIFT_DB_FILE=/data/keys.db \
    SHIFT_LOG_LEVEL=WARNING \
    SHIFT_HTTP_LOG_LEVEL=WARNING \
    SHIFT_SCHEDULE=120 \
    SHIFT_LIMIT=255 \
    SHIFT_SHIFT_SOURCE="https://raw.githubusercontent.com/ugoogalizer/autoshift-codes/main/shiftcodes.json"

# Set working directory
WORKDIR /autoshift

# Install system dependencies
RUN apk update && apk add --no-cache bash curl \
    && rm -rf /var/cache/apk/*

# Copy dependency files first for caching
COPY pyproject.toml uv.lock ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r <(curl -sSL https://raw.githubusercontent.com/Fabbi/autoshift/main/requirements.txt)

# Copy application code
COPY . .

# Expose default port
EXPOSE 8080

# Default command
CMD ["uv", "run", "autoshift"]
