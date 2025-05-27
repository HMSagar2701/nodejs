# Stage 1: Base setup
FROM node:20-slim AS base
WORKDIR /app
COPY . .

# Stage 2: Install production dependencies
FROM base AS prod-deps
RUN npm install --production

# Stage 3: Final lightweight image
FROM node:20-slim AS final
WORKDIR /app
COPY --from=prod-deps /app /app
ENV PORT=3000
EXPOSE 3000
CMD ["node", "index.js"]
