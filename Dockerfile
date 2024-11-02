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

# Install dependencies using npm with exact versions
RUN npm install --legacy-peer-deps \
    @cloudflare/workers-types@4.20241022.0 \
    @remix-run/cloudflare@2.13.1 \
    @remix-run/dev@2.13.1 \
    @remix-run/react@2.13.1 \
    vite@5.4.10 \
    unocss@0.61.9 \
    vite-plugin-node-polyfills@0.22.0 \
    vite-plugin-optimize-css-modules@1.1.0 \
    vite-tsconfig-paths@4.3.2

# Install remaining dependencies
RUN npm install

# Install global tools
RUN npm install -g typescript@5.5.2 wrangler

# Copy the rest of the application
COPY . .

# Generate TypeScript types
RUN npx tsc --declaration

# Start the application
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
