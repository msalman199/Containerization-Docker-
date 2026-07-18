# Use the official Python runtime as the base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV FUNCTION_SOURCE=src/main.py
ENV FUNCTION_TARGET=hello_docker

# Set the working directory in the container
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code
COPY src/ ./src/

# Expose the port that the function will run on
EXPOSE 8080

# Use the Functions Framework to run the function
CMD exec functions-framework --target=${FUNCTION_TARGET} --source=${FUNCTION_SOURCE} --port=8080 --host=0.0.0.0
