#!/bin/bash
set -e  # Exit immediately if any command fails

# =============================================================================
# Script: run_mriqc.sh
# Description: Run MRIQC on longitudinal BIDS dataset's subjects  listed in sub_list file
# Dependencies: MRIQC v24.0.2
#
# Usage:
#	export CORE_PATH=/path/to/project_directory
#	export BIDS_DIR=$CORE_PATH/path/to/bids_validated_dataset_directory
#	export MRIQC_OUTPUT_DIR=$CORE_PATH/mriqc_output
#	mkdir -p $MRIQC_OUTPUT_DIR
#	ml mriqc/24.0.2
#	chmod +x mriqc_run.sh
#	./mriqc_run.sh
#
# =============================================================================


# Check if required environment variables are set
if [ -z "$CORE_PATH" ]; then
	echo "Please export CORE_PATH before running the script."
	echo "Example: export CORE_PATH=/path/to/project_directory"
	exit 1
fi

if [ -z "$BIDS_DIR" ]; then
	echo "Please export BIDS_DIR before running the script."
	echo "Exmple: export BIDS_DIR=/path/to/bids_dataset"
	exit 1
fi

if [ -z "$MRIQC_OUTPUT_DIR" ]; then
	echo "Please  export MRIQC_OUTPUT_DIR before running the script."
	echo "Example: export MRIQC_OUTPUT_DIR=/path/to/mriqc_output"
	exit 1
fi

# File containing participant list
SUB_LIST="${CORE_PATH}/sub_list"

# Check if participant list exists
if [ ! -f "$SUB_LIST" ]; then
	echo "Participant list file not found at $SUB_LIST"
	exit 1
fi 

echo "Starting MRIQC for all participants listed in $SUB_LIST ..."
echo "BIDS dataset: $BIDS_DIR"
echo "MRIQC Output directory: $MRIQC_OUTPUT_DIR"
echo "-----------------------------------------------------------"

# Loop through all participants
while IFS= read -r SUBJECT
do
	if [ -z "$SUBJECT" ]; then
		continue # skip empty lines
	fi

	echo "Processing subject: $SUBJECT"
	
	# Run MRIQC for the participant (all sessions detected automatically)
	mriqc "$BIDS_DIR" "$MRIQC_OUTPUT_DIR" participant  --participant-label "$SUBJECT" --modalities T1w --mem_gb 4 --n_procs 1 --no-sub
	
	echo "Completed MRIQC for $SUBJECT"
	echo "------------------------------------------------------------"

done < "$SUB_LIST" 

# Run group-level MRIQC
echo "Running group-level MRIQC..."
mriqc "$BIDS_DIR" "$MRIQC_OUTPUT_DIR" group --mem_gb 4 --n_procs 1 --no-sub

echo "Completed Group level MRIQC successfully"
