# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 80 to the outside world
EXPOSE 80

# Define environment variables
ENV FLASK_ENV=production
ENV PORT=80

# Run the application using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
