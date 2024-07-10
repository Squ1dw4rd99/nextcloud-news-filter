# Nextcloud News Filter

[source code](https://github.com/Squ1dw4rd99/nextcloud-news-filter)

This Docker image runs a Python script (`main.py`) designed to filter Nextcloud News App feeds. The script can be configured using environment variables and is executed periodically as a cron job.

All credits for the `main.py` file go to the original author, whose repository [nextcloud-news-filter](https://github.com/mathisdt/nextcloud-news-filter) serves as the foundation for this Docker image. For more details and contributions, please visit the original repository.

## Features

- Filters Nextcloud News feeds based on configurable criteria
- Filtered items are marked as read
- Supports title and body regex filters, feed-specific filters, and age-based filters
- Configurable via environment variables for flexibility and ease of use
- Runs as a cron job with customizable intervals

## Environment Variables

The following environment variables are supported for configuring the Nextcloud News Filter:

### Required Variables

- `NEXTCLOUD_ADDRESS`: The URL of your Nextcloud instance.
- `NEXTCLOUD_USERNAME`: Your Nextcloud username.
- `NEXTCLOUD_PASSWORD`: Your Nextcloud password (if you use 2-factor-auth, create an app password).

### Filter Configuration

You can add multiple filters using environment variables. Each filter can be configured for specific feed IDs, titles, bodies, and age. The variables should be named in the format `FILTER_<number>_<type>` where `<type>` can be `TITLE`, `BODY`, `FEED`, or `HOURS`.

- `FILTER_<number>_TITLE`: Regex for matching item titles.
- `FILTER_<number>_BODY`: Regex for matching item bodies.
- `FILTER_<number>_FEED`: ID of the feed to apply the filter.
- `FILTER_<number>_HOURS`: matches items older than this (age in hours and the date is checked via `pubDate`).

*note: don’t use space characters in the regex, instead use* `\s `

### Cron Configuration

- `INTERVAL`: The interval for the cron job (e.g., `*/5 * * * *` for every 5 minutes). Default is `*/5 * * * *`.

## Usage

1. Pull the image from Docker Hub:
   ```sh
   docker pull squ1dw4rd/nextcloud-news-filter
   ```

2. Run the container with the required environment variables:
   ```sh
   docker run -d \
     -e NEXTCLOUD_ADDRESS=https://your-nextcloud-instance.com \
     -e NEXTCLOUD_USERNAME=yourusername \
     -e NEXTCLOUD_PASSWORD=yourpassword \
     -e INTERVAL="*/10 * * * *" \
     -e FILTER_1_TITLE="Anzeige.*" \
     -e FILTER_2_BODY="(advertisement|paid\scontent)" \
     -e FILTER_3_FEED=67 \
     -e FILTER_4_HOURS=72 \
     squ1dw4rd/nextcloud-news-filter
   ```

3. If you want to further configure the script, you can connect to the container and manually edit the `config.ini` file (vi/vim is installed in the container). For more information about the `config.ini`, please visit the original github repository: [nextcloud-news-filter](https://github.com/mathisdt/nextcloud-news-filter)

*note: when you restart the container, any changes made this way will be discarded*

## Examples

To filter out items with titles starting with "Ad" in all feeds every 10 minutes, run the following command:

```sh
docker run -d \
  -e NEXTCLOUD_ADDRESS=https://your-nextcloud-instance.com \
  -e NEXTCLOUD_USERNAME=yourusername \
  -e NEXTCLOUD_PASSWORD=yourpassword \
  -e INTERVAL="*/10 * * * *" \
  -e FILTER_1_TITLE="Ad.*" \
  squ1dw4rd/nextcloud-news-filter
```

The same in docker-compose:

```sh
nextcloud-news-filter:
  image: squ1dw4rd/nextcloud-news-filter
  restart: unless-stopped
  environment:
  - NEXTCLOUD_ADDRESS=https://your-nextcloud-instance.com
  - NEXTCLOUD_USERNAME=yourusername
  - NEXTCLOUD_PASSWORD=yourpassword
  - INTERVAL=*/10 * * * *
  - FILTER_1_TITLE=Ad.*
```

## Logs

The script logs its output to `nextcloud-news-filter.log` within the container.

## Building the image

To build the image yourself, you need the following files:
- [Dockerfile](https://github.com/Squ1dw4rd99/nextcloud-news-filter/blob/36a1e30e2cc5c8d40e38fbccc9052e4c4ba5f719/docker/Dockerfile)
- [create_config.sh](https://github.com/Squ1dw4rd99/nextcloud-news-filter/blob/36a1e30e2cc5c8d40e38fbccc9052e4c4ba5f719/docker/create_config.sh)
- [setup_cron.sh](https://github.com/Squ1dw4rd99/nextcloud-news-filter/blob/36a1e30e2cc5c8d40e38fbccc9052e4c4ba5f719/docker/setup_cron.sh)
- [main.py](https://github.com/Squ1dw4rd99/nextcloud-news-filter/blob/36a1e30e2cc5c8d40e38fbccc9052e4c4ba5f719/main.py)

## Contact information
if you wish to contact me, write an [email](mailto:squ1dw4rd.t3nt4cl3s@proton.me)