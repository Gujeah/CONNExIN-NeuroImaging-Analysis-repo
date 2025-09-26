#!/bin/bash
# Validates BIDS dataset using jsr:@bids/validator via Deno
set -e # Exit immediately if any command fails

CORE_PATH="/path/to/project_directory"
BIDS_DIR="${CORE_PATH}/BIDS_dir"
LOG_DIR="${CORE_PATH}/logs"
mkdir -p "$LOG_DIR"

echo "Validating BIDS dataset at $BIDS_DIR..."
echo "Using: deno run -A jsr:@bids/validator"

# Run BIDS validator
deno run -A jsr:@bids/validator "$BIDS_DIR" --ignoreWarnings > "$LOG_DIR/bids_validation.log" 2>&1

# Check results
if grep -q "This dataset appears to be BIDS compatible" "$LOG_DIR/bids_validation.log"; then
    echo "BIDS validation PASSED"
elif grep -q "error" "$LOG_DIR/bids_validation.log"; then
    echo "BIDS validation FAILED"
    echo "Check full log: $LOG_DIR/bids_validation.log"
    exit 1
else
    echo "BIDS validation completed with warnings"
    echo "Review log for details"
fi

echo "Log saved to: $LOG_DIR/bids_validation.log"