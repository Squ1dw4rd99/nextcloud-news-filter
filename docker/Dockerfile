# docker hub: squ1dw4rd/nextcloud-news-filter
# DOCKERFILE v1.1

# official Python 3 image
FROM python:3

# Set the working directory in the container
WORKDIR /app

# main.py original source: https://github.com/mathisdt/nextcloud-news-filter
COPY main.py /app/

# Copy the script to create config.ini from environment variables
COPY create_config.sh /app/
RUN chmod +x /app/create_config.sh

# Copy the script to setup cron job
COPY setup_cron.sh /app/
RUN chmod +x /app/setup_cron.sh

# Install cron and other dependencies
RUN apt-get update && apt-get install -y cron && apt-get install -y vim
RUN pip install --no-cache-dir requests


# Command to run the cron setup script
CMD ["/app/setup_cron.sh"]