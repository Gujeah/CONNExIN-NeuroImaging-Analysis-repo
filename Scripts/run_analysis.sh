#!/bin/bash

set -e  # Exit on any error
set -u  # Exit on undefined variables

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/analysis_brain_script.py"
LOG_DIR="${SCRIPT_DIR}/logs"
OUTPUT_DIR="${SCRIPT_DIR}/output_dir"

# Create necessary directories
mkdir -p "${LOG_DIR}"
mkdir -p "${OUTPUT_DIR}/plots"
mkdir -p "${OUTPUT_DIR}/output_csv"

# Function to log messages with timestamps
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_DIR}/analysis_$(date '+%Y%m%d').log"
}

# Function to check if required files exist
check_dependencies() {
    log_message "Checking dependencies..."
    
    # Check if Python script exists
    if [[ ! -f "${PYTHON_SCRIPT}" ]]; then
        log_message "ERROR: Python script not found at ${PYTHON_SCRIPT}"
        exit 1
    fi
    
    # Check if required data files exist
    local data_files=(
        "Data/sub-4652225_longitudinal_volumes.tsv"
        "Data/sub-4652225_longitudinal_lh_thickness.tsv"
        "Data/sub-4652225_longitudinal_rh_thickness.tsv"
    )
    
    for file in "${data_files[@]}"; do
        if [[ ! -f "${file}" ]]; then
            log_message "WARNING: Required data file not found: ${file}"
        fi
    done
    
    # Check Python installation if available
    PYTHON_CMD=""
    
    # Try 'python' first 
    if command -v python &> /dev/null; then
        # Test if python actually works (not Windows Store redirect)
        if python -c "import sys; print(sys.version)" &> /dev/null; then
            PYTHON_CMD="python"
            log_message "Found working Python: $(python --version 2>&1)"
        fi
    fi
    
    # Try 'py' as backup 
    if [[ -z "${PYTHON_CMD}" ]] && command -v py &> /dev/null; then
        if py -c "import sys; print(sys.version)" &> /dev/null; then
            PYTHON_CMD="py"
            log_message "Found working Python via 'py' launcher: $(py --version 2>&1)"
        fi
    fi
    
    # Try 'python3' last 
    if [[ -z "${PYTHON_CMD}" ]] && command -v python3 &> /dev/null; then
        if python3 -c "import sys; print(sys.version)" &> /dev/null; then
            PYTHON_CMD="python3"
            log_message "Found working Python3: $(python3 --version 2>&1)"
        fi
    fi
    
    if [[ -z "${PYTHON_CMD}" ]]; then
        log_message "ERROR: No working Python installation found!"
        log_message "Please install Python from https://www.python.org/downloads/"
        log_message "Make sure to check 'Add Python to PATH' during installation."
        exit 1
    fi
    
    # Check required Python packages if installed
    log_message "Checking required Python packages..."
    local required_packages=("pandas" "matplotlib" "numpy")
    local missing_packages=()
    
    for package in "${required_packages[@]}"; do
        if ! ${PYTHON_CMD} -c "import ${package}" &> /dev/null; then
            missing_packages+=("${package}")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_message "ERROR: Missing required Python packages: ${missing_packages[*]}"
        log_message "Install them with: ${PYTHON_CMD} -m pip install ${missing_packages[*]}"
        exit 1
    fi
    
    log_message "Dependencies check completed. Using Python command: ${PYTHON_CMD}"
}

# Function to run the Python analysis
run_analysis() {
    log_message "Starting neuroimaging analysis..."
    
    cd "${SCRIPT_DIR}"
    
    # includeing log message for future referenc eif it breaks
    log_message "Running: ${PYTHON_CMD} ${PYTHON_SCRIPT}"
    
    # Capture both stdout and stderr, and check the actual exit code
    if ${PYTHON_CMD} "${PYTHON_SCRIPT}" > "${LOG_DIR}/python_output_$(date '+%Y%m%d_%H%M%S').log" 2>&1; then
        # Check if the command actually succeeded by looking at the output
        local output_log="${LOG_DIR}/python_output_$(date '+%Y%m%d_%H%M%S').log"
        
        # Checking for common error indicators
        if grep -q "was not found" "${output_log}" || grep -q "Microsoft Store" "${output_log}" || grep -q "not recognized" "${output_log}"; then
            log_message "ERROR: Python execution failed. Check the output:"
            cat "${output_log}" | tee -a "${LOG_DIR}/analysis_$(date '+%Y%m%d').log"
            exit 1
        fi
        
        log_message "Python script execution completed."
        
        # Python output
        log_message "Python script output:"
        cat "${output_log}" | tee -a "${LOG_DIR}/analysis_$(date '+%Y%m%d').log"
        
        # Check if output files were generated
        local expected_outputs=(
            "output_dir/plots/volumetric_trajectory.png"
            "output_dir/plots/volumetric_hipp_ventricle.png"
            "output_dir/plots/volumetric_percent_change.png"
            "output_dir/plots/cortical_thickness_percent_change.png"
            "output_dir/output_csv/summary_volumes_selected_regions.csv"
            "output_dir/output_csv/percent_change_from_baseline.csv"
        )
        
        log_message "Checking output files..."
        local missing_files=0
        for output_file in "${expected_outputs[@]}"; do
            if [[ -f "${output_file}" ]]; then
                log_message "Generated: ${output_file}"
            else
                log_message "Missing: ${output_file}"
                ((missing_files++))
            fi
        done
        
        if [[ ${missing_files} -eq 0 ]]; then
            log_message "All expected output files generated successfully!"
        else
            log_message "WARNING: ${missing_files} expected output files are missing."
            log_message "This suggests the Python script encountered errors."
            exit 1
        fi
        
    else
        log_message "ERROR: Python script failed with exit code $?"
        log_message "Check the Python output log: ${LOG_DIR}/python_output_$(date '+%Y%m%d_%H%M%S').log"
        exit 1
    fi
}

# Function to create a summary report
create_summary() {
    local summary_file="${LOG_DIR}/analysis_summary_$(date '+%Y%m%d_%H%M%S').txt"
    
    cat > "${summary_file}" << EOF
Neuroimaging Analysis Summary
Generated: $(date)
Script Directory: ${SCRIPT_DIR}
Output Directory: ${OUTPUT_DIR}

Analysis Components:
- Longitudinal volume analysis (hippocampus & lateral ventricles)
- Cortical thickness analysis (entorhinal, precuneus, superior temporal)
- Percent change calculations from baseline to follow-up

Output Files Generated:
$(ls -la "${OUTPUT_DIR}/plots/" 2>/dev/null || echo "No plot files found")
$(ls -la "${OUTPUT_DIR}/output_csv/" 2>/dev/null || echo "No CSV files found")

Log Location: ${LOG_DIR}/analysis_$(date '+%Y%m%d').log
EOF

    log_message "Summary report created: ${summary_file}"
}

# Main execution
main() {
    log_message "Neuroimaging Analysis Pipeline"
    log_message "Script: $0"
    log_message "Working directory: $(pwd)"
    
    # Check dependencies
    check_dependencies
    
    # Run the analysis
    run_analysis
    
    # Create summary
    create_summary
    
    log_message "Analysis Pipeline Completed"
}

# Handle command line arguments
case "${1:-run}" in
    "check")
        check_dependencies
        ;;
    "run")
        main
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [check|run|help]"
        echo "  check: Only check dependencies"
        echo "  run:   Run the full analysis (default)"
        echo "  help:  Show this help message"
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac