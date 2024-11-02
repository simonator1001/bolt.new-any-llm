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
COPY package.json ./

# Install dependencies using npm first
RUN npm install

# Install additional dependencies
RUN npm install -D @cloudflare/workers-types @remix-run/cloudflare @types/node vite @remix-run/dev typescript unocss vite-plugin-node-polyfills vite-plugin-optimize-css-modules vite-tsconfig-paths

# Copy the rest of the application
COPY . .

# Production image
FROM base AS bolt-ai-production

ENV NODE_ENV=production \
    WRANGLER_SEND_METRICS=false

# Build the application
RUN npm run build

# Start the application
CMD ["npm", "run", "dockerstart"]

# Development image
FROM base AS bolt-ai-development

ENV NODE_ENV=development

# Start development server
CMD ["npm", "run", "dev", "--host", "0.0.0.0"]
