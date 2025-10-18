# Use the official Nginx Alpine image as the base
FROM nginx:stable-alpine

# Copy your custom nginx.conf into the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (standard HTTP port)
EXPOSE 80
