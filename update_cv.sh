#!/bin/bash
set -e  # Exit on any error

# === CONFIGURATION ===
USER="rikudoukarthik"       # GitHub username/org
REPO="vitae"                # Repo containing CV
BRANCH="main"               # Branch name
REMOTE_FILE="CV.pdf"        # Path to PDF in that repo
RAW_URL="https://raw.githubusercontent.com/$USER/$REPO/$BRANCH/$REMOTE_FILE"

DEST_DIR="static/docs"
RMD_FILE="content/about/sidebar/index.Rmd"  # Rmd file to update
MD_FILE="content/about/sidebar/index.md"    # md file to update

NAME_PREFIX="CV_K-Thrikkadeeri"
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
MONTH_NAME=$(date +"%b")  # Short month name for Rmd text
NEW_FILENAME="${NAME_PREFIX}_${YEAR}${MONTH}.pdf"


# ===== DOWNLOAD =====
echo "Downloading latest CV..."
curl -sL "$RAW_URL" -o "${DEST_DIR}/${NEW_FILENAME}"

# ===== REMOVE OLD FILE(S) =====
echo "Removing old CV file(s)..."
find "$DEST_DIR" -type f -name "${NAME_PREFIX}_*.pdf" ! -name "$NEW_FILENAME" -delete

# ===== UPDATE ABOUT PAGE FILES =====
echo "Updating Rmd & md files..."
# changing hyperlink text (CV (Mon YYYY))
sed -E "s/CV \([A-Za-z]{3} [0-9]{4}\)/CV (${MONTH_NAME} ${YEAR})/" "$RMD_FILE" > "${RMD_FILE}.tmp" && mv "${RMD_FILE}.tmp" "$RMD_FILE"
sed -E "s/CV \([A-Za-z]{3} [0-9]{4}\)/CV (${MONTH_NAME} ${YEAR})/" "$MD_FILE" > "${MD_FILE}.tmp" && mv "${MD_FILE}.tmp" "$MD_FILE"

echo "Done! New CV: $NEW_FILENAME"
