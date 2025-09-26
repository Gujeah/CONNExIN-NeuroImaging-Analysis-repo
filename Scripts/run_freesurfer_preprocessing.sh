#!/bin/bash

# ===============================================================================
# Script: run_freesurfer_preprocessing.sh
# Description: Run FreeSurfer longitudinal preprocessing for all participants
# Dependencies: FreeSurfer v7.4.1
#
# Usage:
# 	export CORE_PATH=/path/to/project_directory
# 	export BIDS_DIR=$CORE_PATH/path/to/bids_validated_dataset_directory
# 	export SUBJECTS_DIR=$CORE_PATH/freesurfer_subjects
#	export FREESURFER_HOME=/path/to/freesurfer/installed/directory
#	chmod +x run_freesurfer_preprocessing.sh
#	./run_freesurfer_preprocessing.sh
# ===============================================================================

# Check required environment variables
for var in CORE_PATH BIDS_DIR SUBJECTS_DIR FREESURFER_HOME; do
	if [ -z "${!var}" ]; then
		echo "Please export $var before running the script."
		exit 1
	fi
done

# Ensure SUBJECTS_DIR exists
mkdir -p "$SUBJECTS_DIR"

# Source FreeSurfer list
source "$FREESURFER_HOME/SetUpFreeSurfer.sh"

# Path to pariticipant list
SUB_LIST="$CORE_PATH/sub_list"

if [ ! -f "$SUB_LIST" ]; then
	echo "Participant list file not found."
	exit 1
fi

echo "Starting FreeSurfer preprocessing for all participants..."
echo "BIDS dataset: $BIDS_DIR"
echo "FreeSurfer subjects dir: $SUBJECTS_DIR"
echo "----------------------------------------------------------------------"

# Loop through all participants
while IFS= read -r SUBJECT
do
	if [ -z "$SUBJECT" ]; then
		continue # skip empty lines
	fi
	
	echo "Preprocessing subject: sub-$SUBJECT"

	# Find all T1w anat files for this participant (all sessions)
	T1_FILES=$(find "$BIDS_DIR/sub-$SUBJECT" -type f -path "*/anat/*_T1w.nii*" | sort)
	if [ -z "$T1_FILES" ]; then
		echo "No T1w scans found for $SUBJECT, skipping."
		continue
	fi

	# 1. Cross-sectional processing for each session
	for T1_FILE in $T1_FILES; do
		# Extract session ID from the path
		SES=$(basename "$(dirname "$(dirname "$T1_FILE")")")
		SUBJ_SES="sub-${SUBJECT}_${SES}"
		
		echo "Running cross-sectional recon-all for $SUBJ_SES ..."
		recon-all -s "$SUBJ_SES" -i "$T1_FILE" -all
	done

	# 2. Base template generation for longitudinal processing
	BASE_SUBJ="sub-${SUBJECT}_base"
	echo "Creating base template for sub-$SUBJECT ..."
	
	# Build the -tp arguments dynamically
	TP_ARGS=""
	for T1_file in $T1_FILES; do
		SES=$(basename "$(dirname "$(dirname "$T1_FILE")")")
		TP_ARGS="$TP_ARGS -tp sub-${SUBJECT}_${SES}"
	done

	recon-all -base "$BASE_SUBJ" $TP_ARGS -all

	# 3. Longitudinal processing for each session
	for T1_FILE in $T1_FILES; do
		SES=$(basename "$(dirname "$(dirname "$T1_FILE")")")
		SUBJ_SES="sub-${SUBJECT}_${SES}"
		echo "Running longitudinal recon-all for $SUBJ_SES ..."
		recon-all -long "$SUBJ_SES" "$BASE_SUBJ" -all
	done
	
	echo "Completed FreeSurfer preprocessing for sub-$SUBJECT"
	echo "--------------------------------------------------------------"

done < "$SUB_LIST"
