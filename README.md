# Longitudinal Analysis of Cortical and Subcortical Volumes in the Prevent-AD Dataset (Structural Team)

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
Radiographer, Kenyatta University Teaching, Referral and Research Hospital, Kenya
