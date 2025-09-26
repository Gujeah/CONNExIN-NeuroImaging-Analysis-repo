# Longitudinal Analysis of Cortical and Subcortical Volumes Pipeline in the Prevent-AD Dataset (Structural Team)

<img src="repo Banner.png" alt="Project Banner" width="100%">

[![Step 1](https://img.shields.io/badge/Step%201-Data%20Organization-blue?style=flat-square)](data/raw/)
[![Step 1](https://img.shields.io/badge/Step%201-Data%20Validation-pink?style=flat-square)](data/bidsfied_data/)
[![Step 2](https://img.shields.io/badge/Step%202-Quality%20Control-orange?style=flat-square)](reports/)
[![Step 3](https://img.shields.io/badge/Step%203-Preprocessing-yellow?style=flat-square)](scripts/run_freesurfer_preprocessing.sh)
[![Step 4](https://img.shields.io/badge/Step%204-Analysis-green?style=flat-square)](Analysis)
[![Step 5](https://img.shields.io/badge/Step%205-Pipeline%20Automation-lightgrey?style=flat-square)](scripts/)
[![Step 6](https://img.shields.io/badge/Step%206-Results%20&%20Figures-purple?style=flat-square)](Analysis/output_dir)
[![Step 7](https://img.shields.io/badge/Step%207-Report%20&%20Docs-red?style=flat-square)](Docs/)

This project implements a **fully reproducible, automated pipeline** to analyze longitudinal structural MRI data from the [Prevent-AD dataset]. We track subtle changes in cortical thickness and subcortical volumes over 12 months in a single at-risk participant, revealing patterns consistent with early Alzheimer’s disease.

**Motivation**: Early detection of structural alterations is critical for understanding disease progression
and identifying individuals at high risk for AD, especially those with a strong family history. The
Prevent-AD dataset provides a unique longitudinal neuroimaging resource that allows researchers to
monitor subtle changes in brain anatomy across multiple timepoints in cognitively unimpaired but
at-risk participants. By investigating structural changes across sessions, researchers can better
understand preclinical AD progression and evaluate imaging biomarkers that may be predictive of
cognitive decline.

**Research Question**: How do participants’ cortical and subcortical volumes change over time in the
Prevent-AD dataset?

**Hypothesis**: We hypothesize that cortical thickness will show progressive decline over time, particularly in temporal and parietal regions, while subcortical volumes will display region-specific atrophy. These patterns reflect structural trajectories commonly observed in the preclinical stages of Alzheimer’s disease.
To address this research question, we applied a **structural imaging analysis pipeline** consisting of BIDS validation, quality control (QC), reconstruction preprocessing, and analysis (extraction of cortical and subcortical measures).

# Project Structure

- **`analysis/`**: Contains the Python analysis script (`analysis.py`) and automatically generated figures.
- **`data/`**: Holds the input data including raw dataset andd longitudinal volumetric and cortical thickness `.tsv` files extracted from FreeSurfer.

  - `raw` → Contains dataset in Bids format

- **`notebooks/`** : Contains notebooks used for trial and error analysis -**`reports/`** : Contains MRIQC reports which were generated from runing mriqc
- **`scripts/`**: Contains a pipeline for end-to-end reproducibility:
  - `bids_validation.sh` → BIDS validation
  - `run_mriqc.sh` → Quality control
  - `run_freesurfer_preprocessing.sh` → FreeSurfer longitudinal processing
  - `analysis.py` → Runs analysis to generate reports

# Results from Analysis

### Volumetric changes

### cortical thinning

# Reproducability

### Prerequsites

### Steps

> Clone this repo:

```bash
git clone https://github.com/Gujeah/CONNExIN-NeuroImaging-Analysis-repo.git
```

# Tools and Technologies used

# Acknowldgements

# Team Members

**Ethel Phiri**

Biomedical Engineering Department, Malawi University of Science and Technology, Thyolo, Malawi

**Bijay Adhikari**
Nepal Research and Collaboration Center, Nepal
Institue of Science and Technology, Birendra Multiple Campus, Tribhuvan University, Nepal

**Zainab Magaji Musa**
Department of Computer Science, Aliko Dangote University of Science and Technology (ADUSTECH), Wudil, Kano, Nigeria
PhD Student, Department of Computer Science, Bayero University Kano (BUK), Kano, Nigeria

**Ernest Obbie Zulu**
UNMISS Level I Clinic, Wau Field Office, Western Bahr El Ghazal, Republic of South Sudan
Radiologist & Postgraduate Student in Neuroimaging for Research, University of Edinburgh, UK

**Leila Osman Hussein**
Radiographer, Kenyatta University Teaching, Referral and Research Hospital, Kenya.
