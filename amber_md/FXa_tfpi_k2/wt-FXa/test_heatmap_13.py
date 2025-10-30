import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MultipleLocator
import re

# Load the dictionary file for the first residue
residue1_dict_df = pd.read_csv('~/Dictionary.csv', delimiter=',', header=None)

# Create mapping dictionary
residue1_dict = dict(zip(residue1_dict_df[0], residue1_dict_df[1]))

# Load the main data file
df = pd.read_csv('merged_result.csv', delimiter=",")

# Function to rename the first residue in column headers
def rename_residues(header):
    if header == '#Frame':
        return header
    parts = header.split('_')  # Assuming format: Residue1_Residue2:Residue3
    if len(parts) == 2:
        renamed_res1 = residue1_dict.get(parts[0], parts[0])
        return f"{renamed_res1}_{parts[1]}"  # Only rename first residue
    return header

# Apply renaming to all columns
df.columns = [rename_residues(col) for col in df.columns]

# Set '#Frame' as index if it exists
if '#Frame' in df.columns:
    df.set_index('#Frame', inplace=True)

# Transpose DataFrame for visualization
df = df.T

# Function to extract the numeric part of the first residue for sorting
def extract_first_residue_number(header):
    match = re.search(r'-(\d+)', header)  # Extract numbers like "147" from "LYS-147"
    return int(match.group(1)) if match else float('inf')

# Sort by the first residue number
df = df.sort_index(key=lambda x: x.map(extract_first_residue_number))

# Function to extract first and second residue separately
def extract_residues(header):
    """ Extracts the first residue and the second residue from the format 'LYS-147_GLU:238' """
    parts = header.split('_')  # Splitting by '_'
    if len(parts) == 2:
        first_residue = parts[0]  # Extract LYS-147
        second_residue = parts[1].replace(':', '-')  # Convert GLU:238 → GLU-238
        return first_residue, second_residue
    return header, "Unknown"

# Group by second residue type
grouped_data = {}
for index in df.index:
    first_res, second_res = extract_residues(index)
    if second_res not in grouped_data:
        grouped_data[second_res] = []
    grouped_data[second_res].append(index)

# Define a **fixed row height per residue**
row_height = 0.4  # Ensures all heatmaps have the same row height

# Get the **maximum** number of residues across all heatmaps
max_residues = max(len(indices) for indices in grouped_data.values())

# Generate heatmaps, ensuring **same row height per residue**
for second_residue, indices in grouped_data.items():
    group_df = df.loc[indices]  # Select only the relevant rows

    # **Set figure height based on row height**  
    fig_height = len(indices) * row_height + 2  # Add margin buffer

    fig, ax = plt.subplots(figsize=(12, fig_height), constrained_layout=True)  # Use constrained layout

    # **Force color scale to be 0-10 for consistency**
    heatmap = sns.heatmap(group_df, cmap='YlGnBu', cbar=True, linewidths=0, vmin=0, vmax=10, ax=ax)

    # **Ensure colorbar always has the tick for 10**
    cbar = heatmap.collections[0].colorbar
    cbar.set_ticks([0, 5, 10])
    cbar.set_ticklabels(["0", "5", "10"])

    # Modify y-axis labels to show only the first residue (e.g., "LYS-147")
    y_labels = [extract_residues(res)[0] for res in group_df.index]

    # **Ensure y-ticks are centered in rows**
    y_ticks = [tick + 0.5 for tick in range(len(y_labels))]
    ax.set_yticks(y_ticks)
    ax.set_yticklabels(y_labels, rotation=0, verticalalignment='center')

    # Add labels and title
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("Residues", labelpad=20, rotation=90, verticalalignment='center')
    ax.set_title(f"Contacts (3 Angstrom) over time - {second_residue}")

    # Customize X-axis ticks
    x_ticks = list(range(0, group_df.shape[1], 5))
    ax.set_xticks(x_ticks)
    ax.set_xticklabels(x_ticks)

    # Adjust minor and major ticks
    ax.xaxis.set_major_locator(MultipleLocator(5))
    ax.xaxis.set_minor_locator(MultipleLocator(1))
    ax.tick_params(which='major', length=10, color='black')
    ax.tick_params(which='minor', length=5, color='gray')

    # **Ensure layout does not cut off labels**
    fig.subplots_adjust(left=0.2, right=0.95, top=0.9, bottom=0.2)  # Adjust margins manually

    # Save the plot
    output_file = f"heatmap_{second_residue}.png"
    plt.savefig(output_file, dpi=300)
    print(f"Heatmap saved as '{output_file}'")
    plt.close(fig)  # Close the figure to free memory

