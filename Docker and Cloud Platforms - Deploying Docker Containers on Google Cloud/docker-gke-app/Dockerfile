# Use official Node.js runtime as base image
FROM node:18-alpine

# Set working directory in container
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy application code
COPY . .

# Expose port 8080
EXPOSE 8080

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Start the application
CMD ["npm", "start"]
