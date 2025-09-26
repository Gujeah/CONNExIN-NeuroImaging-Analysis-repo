

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
# import seaborn as sns
import os
import sys

def wrangle(filepath):
  df=pd.read_csv(filepath, sep='\t', index_col=0)
  df.drop_duplicates(inplace=True)
  ### mapping session since they are so long
  session_map = {
    'sub-4652225_ses-PREBL00.long.sub-4652225_base': 'Baseline (PREBL00)',
    'sub-4652225_ses-PREEN00.long.sub-4652225_base': 'Mid (PREEN00)',
    'sub-4652225_ses-PREFU12.long.sub-4652225_base': 'Follow-up (PREFU12)'
}
  df.index = df.index.map(session_map)
  df.index.name="Session"
  return df

### the dataset
longitudinal_volume='Data\sub-4652225_longitudinal_volumes.tsv'
long_thick_lh='Data\sub-4652225_longitudinal_lh_thickness.tsv'
long_thick_rh='Data\sub-4652225_longitudinal_rh_thickness.tsv'

data = wrangle(longitudinal_volume)
data.head(3)

data.T

data.columns

##### There are regions of our interests

regions = [
     'Left-Hippocampus',
    'Right-Hippocampus',
    'Left-Lateral-Ventricle',
    'Right-Lateral-Ventricle'

]

plots = data[regions]
plots

def plot_hippocampus_ventricles(data, output_dir, filename="hippocampus_ventricles_longitudinal.png"):

    # Regions of our interests
    small_regions = [
        'Left-Hippocampus',
        'Right-Hippocampus',
        'Left-Lateral-Ventricle',
        'Right-Lateral-Ventricle'
    ]

    # Making our dataframe like what we did before but inside the function
    plots_small = data[small_regions]

    # fig size parameter
    plt.figure(figsize=(15, 10))

    # looping to all the regions
    for region in small_regions:
        plt.plot(plots_small.index, plots_small[region], marker='o', label=region, linewidth=2.5)

    # Get baseline and follow-up for % change
    baseline = plots_small.iloc[0]
    followup = plots_small.iloc[-1]

    # Add % change labels
    for region in small_regions:
        pct_change = ((followup[region] - baseline[region]) / baseline[region]) * 100
        final_val = followup[region]
        plt.text(len(plots_small) - 0.2, final_val, f'{pct_change:+.1f}%',
                 fontsize=10, ha='left', va='center', fontweight='bold')

    # Labeling
    plt.title('Longitudinal Change in Hippocampus & Lateral Ventricles', fontsize=16, fontweight='bold')
    plt.xlabel('Session', fontsize=12)
    plt.ylabel('Volume (mm³)', fontsize=12)
    plt.xticks(rotation=45, ha='right')
    plt.legend(fontsize=11, loc='upper left')
    plt.grid(True, linestyle='--', alpha=0.6)

    # Zooming  y-axis since sometimes it looks so small
    y_min = plots_small.min().min() - 100
    y_max = plots_small.max().max() + 100
    plt.ylim(y_min, y_max)

    plt.tight_layout()

    # output directory where our figures will be stored. we used exist_ok to confirm. if it is not then create one
    os.makedirs(output_dir, exist_ok=True)

    # Saving our plot
    output_path = os.path.join(output_dir, filename)
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Saving to: {output_path}")

plot_hippocampus_ventricles(
    data=data,
    output_dir="output_dir\plots",
    filename="volumetric_trajectory.png"
)



def plot_hippocampus_vs_ventricles(plots, baseline, followup, output_dir, filename="hipp_vs_ventricle_separate.png"):
   
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))

    # =Hippocampus Plot =
    hipp_regions = ['Left-Hippocampus', 'Right-Hippocampus']
    for region in hipp_regions:
        axes[0].plot(plots.index, plots[region], marker='o', label=region, linewidth=2.5)
    axes[0].set_title('Hippocampal Volume Decline', fontsize=14, fontweight='bold')
    axes[0].set_ylabel('Volume (mm³)', fontsize=12)
    axes[0].legend(fontsize=10)
    axes[0].grid(True, linestyle='--', alpha=0.6)
    y_min_hipp = plots[hipp_regions].min().min() - 50
    y_max_hipp = plots[hipp_regions].max().max() + 50
    axes[0].set_ylim(y_min_hipp, y_max_hipp)

    #  % change labels
    for region in hipp_regions:
        pct_change = ((followup[region] - baseline[region]) / baseline[region]) * 100
        final_val = followup[region]
        axes[0].text(len(plots) - 0.2, final_val, f'{pct_change:+.1f}%',
                     fontsize=9, ha='left', va='center')

    # =Lateral Ventricles Plot =
    ventricle_regions = ['Left-Lateral-Ventricle', 'Right-Lateral-Ventricle']
    for region in ventricle_regions:
        axes[1].plot(plots.index, plots[region], marker='s', label=region, linewidth=2.5)
    axes[1].set_title('Lateral Ventricle Expansion', fontsize=14, fontweight='bold')
    axes[1].set_xlabel('Session', fontsize=12)
    axes[1].set_ylabel('Volume (mm³)', fontsize=12)
    axes[1].legend(fontsize=10)
    axes[1].grid(True, linestyle='--', alpha=0.6)
    y_min_vent = plots[ventricle_regions].min().min() - 50
    y_max_vent = plots[ventricle_regions].max().max() + 50
    axes[1].set_ylim(y_min_vent, y_max_vent)

    # % change labels
    for region in ventricle_regions:
        pct_change = ((followup[region] - baseline[region]) / baseline[region]) * 100
        final_val = followup[region]
        axes[1].text(len(plots) - 0.2, final_val, f'{pct_change:+.1f}%',
                     fontsize=9, ha='left', va='center')

    # Final layout
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()

    # Save to file
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, filename)
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close(fig) 
    print(f"Side-by-side plot saved to: {output_path}")

plots = data[[
    'Left-Hippocampus', 'Right-Hippocampus',
    'Left-Lateral-Ventricle', 'Right-Lateral-Ventricle'
]]

baseline = plots.iloc[0]
followup = plots.iloc[-1]

# Calling the function
plot_hippocampus_vs_ventricles(
    plots=plots,
    baseline=baseline,
    followup=followup,
    output_dir="output_dir\plots",
    filename="volumetric_hipp_ventricle.png"
)



def plot_percent_change_barplot(plots, output_dir, filename="percent_change_barplot.png"):
   
    # Regions of our interest
    key_regions = [
        'Left-Hippocampus',
        'Right-Hippocampus',
        'Left-Lateral-Ventricle',
        'Right-Lateral-Ventricle'
    ]

    # Copying files incase of anythifn
    df = plots[key_regions].copy()

    # % change from baseline (row 0) to each session
    percent_change = ((df - df.iloc[0]) / df.iloc[0] * 100).round(2)
    followup_pct = percent_change.iloc[-1]  # Last session

    # bar plot
    plt.figure(figsize=(15, 10))
    bars = plt.bar(
        followup_pct.index,
        followup_pct.values,
        color=['#d62728', '#d62728', '#1f77b4', '#1f77b4'],  # Red = hippocampus (loss), Blue = ventricles (gain)
        alpha=0.85,
        edgecolor='black',
        linewidth=1.2
    )

    # labelling
    for bar in bars:
        height = bar.get_height()
        plt.text(
            bar.get_x() + bar.get_width() / 2.,
            height + 0.05,
            f'{height:+.1f}%',
            ha='center',
            va='bottom',
            fontweight='bold',
            fontsize=11
        )

    # Adding more flavor
    plt.title('Percent Change from Baseline to Follow-up', fontsize=15, fontweight='bold')
    plt.xlabel('Brain Region', fontsize=12)
    plt.ylabel('Volume Change (%)', fontsize=12)
    plt.xticks(rotation=45, ha='right')
    plt.axhline(0, color='gray', linestyle='--', linewidth=1)
    plt.grid(axis='y', linestyle='--', alpha=0.6)
    plt.tight_layout()

    # saving the file
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, filename)
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close() 
    print(f"Percent change bar plot saved to: {output_path}")

# same key regions. im just repeating the same dont want to get lost. will clean this later
plots =  data[[
    'Left-Hippocampus',
    'Right-Hippocampus',
    'Left-Lateral-Ventricle',
    'Right-Lateral-Ventricle'
]]

# Calling the function
plot_percent_change_barplot(
    plots=plots,
    output_dir="output_dir\plots",
    filename="volumetric_percent_change.png"
)

# Saveing the table that has region of out
plots.to_csv('output_dir/output_csv/summary_volumes_selected_regions.csv')

# Calculate % change from baseline
baseline_row = plots.iloc[0]
percent_change = ((plots - baseline_row) / baseline_row * 100).round(2)
percent_change.to_csv('output_dir/output_csv/percent_change_from_baseline.csv')

print("Exported: summary_volumes_selected_regions.csv")
print("Exported: percent_change_from_baseline.csv")

volume_summary=pd.read_csv("output_dir/output_csv/percent_change_from_baseline.csv")
volume_summary.head()




"""Cortical"""

### for Cortical

lh=wrangle(long_thick_lh)
rh=wrangle(long_thick_rh)

lh.head()

lh.columns

rh.columns

thickness = pd.concat([lh, rh], axis=1)

import os
import matplotlib.pyplot as plt

def plot_cortical_thickness_barplot(baseline, followup, output_dir, filename="cortical_thinning_barplot.png"):
    
    # Regions of interest
    key_regions = [
        'lh_entorhinal_thickness',
        'rh_entorhinal_thickness',
        'lh_precuneus_thickness',
        'rh_precuneus_thickness',
        'lh_superiortemporal_thickness',
        'rh_superiortemporal_thickness'
    ]

    # Full human-readable labels 
    full_labels = [
        'Left Entorhinal Cortex',
        'Right Entorhinal Cortex',
        'Left Precuneus',
        'Right Precuneus',
        'Left Superior Temporal Gyrus',
        'Right Superior Temporal Gyrus'
    ]

    # % change
    pct_change = ((followup[key_regions] - baseline[key_regions]) / baseline[key_regions] * 100).round(2)

    # bar plot
    plt.figure(figsize=(12, 7))
    bars = plt.bar(
        full_labels,
        pct_change.values,
        color='#1f77b4',  
        alpha=0.85,
        edgecolor='black',
        linewidth=1.2
    )

    # % change labels  
    for i, bar in enumerate(bars):
        height = bar.get_height()
        if height < 0:
            plt.text(i, height + 0.05, f'{height:+.1f}%',
                     ha='center', va='bottom',
                     fontweight='bold', fontsize=11, color='white')
        else:
            plt.text(i, height + 0.05, f'{height:+.1f}%',
                     ha='center', va='bottom',
                     fontweight='bold', fontsize=11, color='black')

    # Customizing
    plt.title('Cortical Thinning: Baseline to Follow-up', fontsize=15, fontweight='bold')
    plt.xlabel('Brain Region', fontsize=12)
    plt.ylabel('Thickness Change (%)', fontsize=12)
    plt.xticks(rotation=45, ha='right', fontsize=11)
    plt.axhline(0, color='gray', linestyle='--', linewidth=1)
    plt.grid(axis='y', linestyle='--', alpha=0.6)
    plt.tight_layout()

    # Save to file
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, filename)
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close() 
    print(f"Cortical thickness bar plot saved to: {output_path}")


baseline = thickness.iloc[0]   # for Baseline session
followup = thickness.iloc[-1]  # for Follow-up session

# Calling the function
plot_cortical_thickness_barplot(
    baseline=baseline,
    followup=followup,
    output_dir="output_dir\plots",
    filename="cortical_thickness_percent_change.png"
)

