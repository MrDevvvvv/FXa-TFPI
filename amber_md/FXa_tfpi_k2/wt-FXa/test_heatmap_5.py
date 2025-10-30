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

# Generate separate heatmaps for each second residue type
for second_residue, indices in grouped_data.items():
    group_df = df.loc[indices]  # Select only the relevant rows

    plt.figure(figsize=(12, 8))
    sns.heatmap(group_df, cmap='YlGnBu', cbar=True, linewidths=0, cbar_kws={"ticks": [0, 10]})

    # Modify y-axis labels to show only the first residue (e.g., "LYS-147")
    y_labels = [extract_residues(res)[0] for res in group_df.index]
    plt.yticks(ticks=range(len(y_labels)), labels=y_labels, rotation=0)

    # Add labels and title
    plt.xlabel("Time (ns)")
    plt.ylabel("Residues", labelpad=20, rotation=90, verticalalignment='center')
    plt.title(f"Contacts (3 Angstrom) over time - {second_residue}")

    # Customize X-axis ticks
    x_ticks = list(range(0, group_df.shape[1], 5))
    plt.xticks(ticks=x_ticks, labels=x_ticks)

    ax = plt.gca()  # Get current axis
    ax.xaxis.set_major_locator(MultipleLocator(5))
    ax.xaxis.set_minor_locator(MultipleLocator(1))
    ax.tick_params(which='major', length=10, color='black')
    ax.tick_params(which='minor', length=5, color='gray')

    # Save the plot
    output_file = f"heatmap_{second_residue}.png"
    plt.tight_layout()
    plt.savefig(output_file, dpi=300)
    print(f"Heatmap saved as '{output_file}'")

