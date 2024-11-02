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

# Create a package-lock.json if it doesn't exist
RUN npm install --package-lock-only

# Install dependencies using npm
RUN npm ci --legacy-peer-deps

# Install additional dependencies explicitly
RUN npm install --save-dev --legacy-peer-deps \
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

# Generate TypeScript types
RUN npx tsc --declaration --emitDeclarationOnly

# Production image
FROM base AS bolt-ai-production

ENV NODE_ENV=production \
    WRANGLER_SEND_METRICS=false

# Configure wrangler
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

# Install wrangler globally
RUN npm install -g wrangler

# Build the application
RUN npm run build

# Start the application
CMD ["npm", "run", "dockerstart"]

# Development image
FROM base AS bolt-ai-development

ENV NODE_ENV=development

# Start development server
CMD ["npm", "run", "dev", "--host", "0.0.0.0"]
