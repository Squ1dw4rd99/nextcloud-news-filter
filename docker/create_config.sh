#!/bin/bash
# create_config.sh v1.5
# This script generates the config.ini file for the Nextcloud News Filter

# Exit if required environment variables are not set
if [[ -z "$NEXTCLOUD_ADDRESS" || -z "$NEXTCLOUD_USERNAME" || -z "$NEXTCLOUD_PASSWORD" ]]; then
    echo "Error: NEXTCLOUD_ADDRESS, NEXTCLOUD_USERNAME, and NEXTCLOUD_PASSWORD must be set."
    exit 1
fi

# Initialize config.ini content
cat <<EOF > /app/config.ini
[login]
address = $NEXTCLOUD_ADDRESS
username = $NEXTCLOUD_USERNAME
password = $NEXTCLOUD_PASSWORD

# The names of the following sections are not specified, use as description of the filter.
# optional parameter feedId -> apply only in this feed
# optional parameter titleRegex -> apply to item titles
# optional parameter bodyRegex -> apply to item bodies
# optional parameter hoursAge -> apply if item's "pubDate" is older than this
EOF

# Function to append filter settings to the config
append_filter() {
    local filter_number=$1
    local filter_type=$2
    local filter_value=$3

    local filter_name="filter $filter_number"

    echo "Appending filter: $filter_name [$filter_type = $filter_value]"

    if grep -q "^\[$filter_name\]" /app/config.ini; then
        sed -i "/^\[$filter_name\]/a $filter_type = $filter_value" /app/config.ini
    else
        cat <<EOF >> /app/config.ini

[$filter_name]
$filter_type = $filter_value
EOF
    fi
}

# Collect filters in an array
filters=()
for var in $(env); do
    if [[ $var == FILTER_* ]]; then
        filters+=("$var")
    fi
done

# Sort filters by filter_number
IFS=$'\n' sorted_filters=($(sort -t'_' -k2,2n <<<"${filters[*]}"))
unset IFS

# Process sorted filters
for var in "${sorted_filters[@]}"; do
    filter_number=$(echo "$var" | cut -d'_' -f2)
    filter_property=$(echo "$var" | cut -d'_' -f3)
    filter_name=$(echo "$filter_property" | cut -d'=' -f1 | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    filter_value=$(echo "$var" | cut -d'=' -f2-)

    echo "Processing: filter_number=$filter_number, filter_name=$filter_name, filter_value=$filter_value"

    case $filter_name in
        title)
            append_filter "$filter_number" "titleRegex" "$filter_value"
            ;;
        body)
            append_filter "$filter_number" "bodyRegex" "$filter_value"
            ;;
        feed)
            append_filter "$filter_number" "feedId" "$filter_value"
            ;;
        hours)
            append_filter "$filter_number" "hoursAge" "$filter_value"
            ;;
        *)
            echo "Warning: Unsupported filter name '$filter_name' for filter_number=$filter_number."
            ;;
    esac
done
