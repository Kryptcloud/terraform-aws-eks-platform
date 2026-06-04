# ==========================================
# STAGE 1: THE BUILD STAGE (Development)
# ==========================================
FROM node:20-alpine AS builder

# Set the active internal workspace folder
WORKDIR /app

# Copy dependency mappings first to leverage cached image layers
COPY package*.json ./

# Install all dependencies (including development tools)
RUN npm ci

# Copy the rest of my application source code into the layer
# (This brings in tsconfig.json and the app/src folder perfectly)
COPY . .

# Build my production assets (e.g., compile TypeScript or minify code)
RUN npm run build


# ==========================================
# STAGE 2: THE RUNTIME VAULT (Production)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# Enforce Node.js production performance optimizations
ENV NODE_ENV=production

# Setup a dedicated non-root security user group for Kubernetes compliance
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy ONLY the production code and artifacts from Stage 1
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Install production-only dependencies to minimize the final footprint
RUN npm ci --only=production

# Strip root administrative ownership permissions for security hardening
USER nextjs

# Inform network engines that the app listens on port 3000
EXPOSE 3000

# The execution hook that boots your application container
CMD ["node", "dist/index.js"]
