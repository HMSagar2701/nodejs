# Node.js App with Docker

This is a simple Node.js application containerized with Docker using a multi-stage build to reduce image size.

## Docker Commands

### Build the image

```bash
docker build -t nodejs-app .
Run the container
bash
Copy
Edit
docker run -p 3000:3000 nodejs-app
Multi-stage Dockerfile example
dockerfile
Copy
Edit
# Stage 1: Build stage
FROM node:18 AS build-stage

# Metadata labels (optional)
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Node.js app multi-stage build"

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source code
COPY . .

# Stage 2: Production stage
FROM node:18-slim AS production-stage

# Metadata labels (optional)
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Node.js app production image"

# Set working directory
WORKDIR /app

# Copy only node_modules and built source from build-stage
COPY --from=build-stage /app/node_modules ./node_modules
COPY --from=build-stage /app .

# Expose port 3000
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
yaml
Copy
Edit

---

### Explanation:

- **Stage 1 (build-stage):** Installs all dependencies (including dev dependencies if any), copies all code.
- **Stage 2 (production-stage):** Uses a smaller base image (`node:18-slim`), copies only necessary files + `node_modules` from build stage, resulting in a slimmer final image.