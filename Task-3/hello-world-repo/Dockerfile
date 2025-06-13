# Use Python 3.8 slim as the base image
FROM python:3.8-slim

# Set working directory inside the container
WORKDIR /app

# Copy dependencies file
COPY requirements.txt .

# Install Python packages
RUN pip install -r requirements.txt

# Copy all project files
COPY . .

# Run the app
CMD ["python", "app.py"]
