# Use an official Node.js runtime as a parent image
FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock) files to the container
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the rest of the application's source code to the container
COPY . .

# Build the React application
RUN npm run build

# Use an official Nginx image as the base image for serving the built files
FROM nginx:alpine

# Copy the built files from the previous stage to the Nginx container
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app will run on
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
