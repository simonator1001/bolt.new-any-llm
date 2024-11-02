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
RUN npm install

# Install global dependencies and link them
RUN npm install -g \
    @remix-run/dev@2.13.1 \
    typescript@5.5.2 \
    wrangler && \
    npm link @remix-run/dev

# Install additional dependencies explicitly
RUN npm install --save-dev --legacy-peer-deps \
    @cloudflare/workers-types@4.20241022.0 \
    @remix-run/cloudflare@2.13.1 \
    @remix-run/dev@2.13.1 \
    @remix-run/react@2.13.1 \
    vite@5.4.10 \
    unocss@0.61.9 \
    vite-plugin-node-polyfills@0.22.0 \
    vite-plugin-optimize-css-modules@1.1.0 \
    vite-tsconfig-paths@4.3.2

# Copy the rest of the application
COPY . .

# Create a bin directory and add it to PATH
RUN mkdir -p /app/node_modules/.bin && \
    ln -s /usr/local/bin/remix /app/node_modules/.bin/remix

# Set PATH to include node_modules/.bin
ENV PATH="/app/node_modules/.bin:${PATH}"

# Start the application
CMD ["npm", "run", "dev"]
