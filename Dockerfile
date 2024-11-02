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

# Install pnpm
RUN npm install -g pnpm@9.4.0

# Enable pnpm
RUN corepack enable pnpm

# Copy package files first
COPY package.json ./

# Install dependencies using pnpm
RUN pnpm install --no-lockfile

# Install additional dependencies explicitly
RUN pnpm add -D \
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
RUN pnpm exec tsc --declaration --emitDeclarationOnly

# Production image
FROM base AS bolt-ai-production

ENV NODE_ENV=production \
    WRANGLER_SEND_METRICS=false

# Configure wrangler
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

# Install wrangler globally
RUN pnpm add -g wrangler

# Build the application
RUN pnpm run build

# Start the application
CMD ["pnpm", "run", "dockerstart"]

# Development image
FROM base AS bolt-ai-development

ENV NODE_ENV=development

# Start development server
CMD ["pnpm", "run", "dev", "--host", "0.0.0.0"]
