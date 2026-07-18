FROM python:3.9-slim

WORKDIR /app

# Install required packages
RUN pip install flask redis

# Copy application code
COPY app.py .

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
