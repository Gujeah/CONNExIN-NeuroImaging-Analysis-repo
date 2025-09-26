# Neuroimaging Analysis Pipeline

This pipeline performs longitudinal neuroimaging analysis on FreeSurfer-processed data, focusing on hippocampal volume changes and cortical thickness measurements in regions associated with neurodegeneration.

# Overview

The pipeline consists of four main stages:

BIDS Validation - Ensures data follows BIDS standard
MRIQC - Quality control of raw MRI data
FreeSurfer Processing - Structural image processing
Statistical Analysis - Longitudinal volume and thickness analysis

# Prerequisites

## System Requirements

Operating System: Linux, macOS, or Windows (with Git Bash)
RAM: Minimum 8GB, recommended 16GB+
Storage: At least 10GB free space
Internet: Required for software installation

# Software Dependencies

## Required Software

Python 3.7+
Download from: https://www.python.org/downloads/
Important: During installation, check "Add Python to PATH"

Neurodesk
[Neurodesk](https://neurodesk.org/)

Git
Download from: https://git-scm.com/downloads

FreeSurfer (for preprocessing stages)

Download from: https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall
Requires registration and license

# Installation of libralies (that if if you want to perform analysis step in your local machine)

```bash
pip install pandas matplotlib numpy seaborn os-sys

```

# Installation and Setup

1. Clone the repository

```bash
git clone https://github.com/Gujeah/CONNExIN-NeuroImaging-Analysis-repo.git
```

2. Upload your zipped file to neurodesk and unzip it

```bash
unzip your_file_name.zip
```

3. Make the scripts excutable by

````bash
chmod +x *.sh ```

````

4. run bids validation by performing commands below in order

```bash
chmod+x bids_validation.sh
```

```bash
./bids_validation.sh
```

5. Run MRIQC for quality control

```bash
chmod+x run_mriqc.sh
```

```bash
./run_mriqc.sh
```

6. Run freefurfer to preprocess data.
   This step is hard to do on neurodesk becasue of crashing issue. The best way is to use independed free sufer

```bash
   chmod+x run_freesurfer.sh
```

```bash
./run_freesurfer.sh
```

7. Run analysis script to generate all graphs and csv files

```bash
chmod+x run_analysis.sh
```

```bash
./run_analysis.sh
```
