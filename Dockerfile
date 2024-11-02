ARG BASE=node:20.18.0
FROM ${BASE} AS base

WORKDIR /app

# Install system dependencies and development tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm using npm
RUN npm install -g pnpm@9.4.0 \
    @cloudflare/workers-types \
    @remix-run/dev \
    vite \
    typescript

# Copy package files first for better caching
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy the rest of the application
COPY . .

# Install type definitions that were missing
RUN pnpm add -D @cloudflare/workers-types @remix-run/cloudflare @types/node vite

# Production image
FROM base AS bolt-ai-production

ENV NODE_ENV=production \
    WRANGLER_SEND_METRICS=false

# Build the application
RUN pnpm run build

# Start the application
CMD ["pnpm", "run", "dockerstart"]

# Development image
FROM base AS bolt-ai-development

ENV NODE_ENV=development

# Start development server
CMD ["pnpm", "run", "dev", "--host", "0.0.0.0"]
