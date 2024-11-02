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

# Copy package files first
COPY package*.json ./

# Install dependencies using npm
RUN npm install --legacy-peer-deps

# Install global dependencies
RUN npm install -g \
    wrangler \
    @remix-run/dev \
    typescript

# Install additional dependencies explicitly
RUN npm install --save-dev \
    @cloudflare/workers-types@4.20241022.0 \
    @remix-run/cloudflare@2.13.1 \
    @remix-run/dev@2.13.1 \
    @remix-run/react@2.13.1 \
    @types/node \
    typescript \
    vite \
    unocss \
    vite-plugin-node-polyfills \
    vite-plugin-optimize-css-modules \
    vite-tsconfig-paths \
    @blitz/eslint-plugin \
    sass \
    sass-embedded \
    vitest

# Copy the rest of the application
COPY . .

# Configure wrangler
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

# Build the application
RUN npx remix build

# Start the application
CMD ["npx", "remix", "vite:dev", "--host", "0.0.0.0"]
