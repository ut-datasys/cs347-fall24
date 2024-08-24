#!/bin/bash

# Read the TSV file
input_file="input.tsv"
counter=1

# Define the timezone offset and time
timezone_offset="-05:00"
time="14:00:00"

# Use a while loop to read each line, parsing the TSV correctly
while IFS=$'\t' read -r date topic note; do
    # Remove any surrounding quotes from the fields
    date=$(echo "$date" | sed 's/^"//;s/"$//')
    topic=$(echo "$topic" | sed 's/^"//;s/"$//')

    # Convert date to YYYY-MM-DD format
    formatted_date=$(awk -F/ '{print $3"-"$1"-"$2}' <<< "$date")
    
    # Append the time and timezone offset
    formatted_date_time="${formatted_date}T${time}${timezone_offset}"

    # If the note field exists, clean it up
    if [ -n "$note" ]; then
        note=$(echo "$note" | sed 's/^"//;s/"$//')
    fi

    # Format the file number to two digits
    file_number=$(printf "%02d" "$counter")
    
    # Create the filename
    output_file="${file_number}.md"
    
    # Remove "Lecture" from the topic if it exists
    formatted_topic=$(echo "$topic" | sed 's/^Lecture //')
    
    # Write the markdown content
    echo "---" > "$output_file"
    echo "type: lecture" >> "$output_file"
    echo "date: \"$formatted_date_time\"" >> "$output_file"
    echo "title: '$formatted_topic'" >> "$output_file"
    echo "---" >> "$output_file"
    
    # Add the note if it exists
    if [ -n "$note" ]; then
        echo "$note" >> "$output_file"
    fi
    
    # Increment the counter for the next file
    counter=$((counter + 1))
done < "$input_file"
