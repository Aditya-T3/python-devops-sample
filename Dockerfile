# Use official Python base image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /app

# Copy all files into container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make setup.sh executable
RUN chmod +x setup.sh

# Run setup.sh when container starts
CMD ["./setup.sh"]