#!/bin/bash

# Get current date info
YEAR=$(date +%Y)
MONTH_NUM=$(date +%m)
MONTH_NAME=$(date +%B)
DAY=$(date +%d)
WEEK_NUM=$(( (10#$(date +%d) - 1) / 7 + 1 ))  # Week number within the month (1–4)
DATE_FILE="$YEAR-$MONTH_NUM-$DAY.md"

# Folder paths
BASE_DIR="$YEAR/${MONTH_NUM}-${MONTH_NAME}/Week-0${WEEK_NUM}"
MEETING_DIR="$YEAR/${MONTH_NUM}-${MONTH_NAME}/meetings"

# Create directories
mkdir -p "$BASE_DIR"
mkdir -p "$MEETING_DIR"

# Create daily log file if not exists
if [ ! -f "$BASE_DIR/$DATE_FILE" ]; then
    echo "# Daily Log - $DATE_FILE" > "$BASE_DIR/$DATE_FILE"
    echo "Created: $BASE_DIR/$DATE_FILE"
else
    echo "File already exists: $BASE_DIR/$DATE_FILE"
fi

# Create meeting notes file (in monthly folder)
MEETING_FILE="$MEETING_DIR/${DATE_FILE%.md}-meeting.md"
if [ ! -f "$MEETING_FILE" ]; then
    echo "# Meeting Notes - $DATE_FILE" > "$MEETING_FILE"
    echo "Created: $MEETING_FILE"
else
    echo "Meeting file already exists: $MEETING_FILE"
fi

# Git add, commit, and push
git add .
git commit -m "Add daily and meeting logs for $DATE_FILE"
git pull --rebase origin main
git push origin main

