#!/bin/bash
# === newday.sh ===
# Creates an empty daily Markdown file under year/month/week folders

# Date components
YEAR=$(date +%Y)
MONTH_NUM=$(date +%m)
MONTH_NAME=$(date +%B)
DAY=$(date +%d)
DATE=$(date +%Y-%m-%d)

# Determine week of month (1-based)
WEEK_NUM=$(( ((10#$DAY - 1) / 7) + 1 ))
WEEK_FOLDER="Week-$(printf "%02d" $WEEK_NUM)"

# Build path
FOLDER="$YEAR/$MONTH_NUM-$MONTH_NAME/$WEEK_FOLDER"
FILE="$FOLDER/$DATE.md"

# Make directories if needed
mkdir -p "$FOLDER"

# Create file if missing
if [ ! -f "$FILE" ]; then
  echo "# $DATE" > "$FILE"
  echo "Created: $FILE"
else
  echo "File already exists: $FILE"
fi

# Commit and push
git add "$FILE"
git commit -m "Add daily log for $DATE"
git push origin main

# Optionally open file in VS Code
if command -v code &> /dev/null; then
  code "$FILE"
fi
