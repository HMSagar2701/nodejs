# Stage 1: Base setup
FROM node:20-slim AS base
ENV NPM_HOME="/npm"
ENV PATH="$NPM_HOME:$PATH"
WORKDIR /app
COPY . .

# Stage 2: Install production dependencies only
FROM base AS prod-deps
RUN --mount=type=cache,id=npm,target=/npm/store \
    npm install --production --frozen-lockfile

# Stage 3: Build stage (for TypeScript or frontend assets, if needed)
FROM base AS build
RUN npm install
RUN npm run build

# Stage 4: Final minimal image
FROM node:20-slim AS final
WORKDIR /app

# Copy production dependencies
COPY --from=prod-deps /app/node_modules ./node_modules

# Copy app files
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/dist ./dist

# Environment config and launch
ENV PORT=3000
EXPOSE 3000
CMD ["node", "dist/index.js"]
