FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Make sure /tmp has the correct permissions
RUN chmod 1777 /tmp

# Install system dependencies
RUN apt-get update && \
    apt-get install -y apt-utils debconf build-essential && \
    apt-get install -y python3-dev python3-pip make && \
    apt-get clean && apt-get autoremove

# Copy dependency files to leverage Docker cache
COPY pyproject.toml poetry.lock ./

# Install Poetry and Python dependencies
RUN pip install poetry --break-system-packages && \
    poetry install --no-root

# Copy the rest of the application code
COPY . .

# Expose the port your app runs on
EXPOSE 8000

# Start the app using the Makefile's 'run' target
#CMD ["make", "run"]
#CMD ["sh", "-c", "make db-init && make run"]
CMD ["sh", "-c", "make run"]
