
# First Stage: Build the Java Library with Maven
FROM maven:3.8.4-openjdk-11 AS java-builder

# Set the working directory
WORKDIR /app/java-library

# Copy the Java library source code
COPY java-library/pom.xml .
COPY java-library/src ./src

# Build the Java library
RUN mvn clean install

# Second Stage: Build the Node.js Application
FROM node:14 AS node-builder

# Set the working directory
WORKDIR /app/node-app

# Copy package.json and package-lock.json
COPY node-app/package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the Node.js application source code
COPY node-app/ .

# Build the Node.js application
RUN npm run build

# Third Stage: Create the Final Image
FROM node:14-alpine AS final

# Set the working directory
WORKDIR /app

# Copy the built Node.js application from the node-builder stage
COPY --from=node-builder /app/node-app/build ./node-app/build

# Copy the built Java library from the java-builder stage
COPY --from=java-builder /app/java-library/target/*.jar ./java-library/

# Install any necessary runtime dependencies
RUN apk add --no-cache openjdk11-jre

# Expose the port your application runs on (e.g., 3000 for a Node.js app)
EXPOSE 3000

# Define the command to run your application
CMD ["node", "node-app/build/index.js"]

