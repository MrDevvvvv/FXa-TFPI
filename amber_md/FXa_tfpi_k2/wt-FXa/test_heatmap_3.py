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
    parts = header.split('_')  # Assuming format: Residue1_Residue2
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
# Adjusted to extract number before ':' in format like LYS-47:ARG-244
def extract_first_residue_number(header):
    match = re.search(r'-(\d+)_', header)
    if match:
        return int(match.group(1))  # Extract numeric part before ':'
    return float('inf')  # Ensure non-numeric values go to the end

# Sort by the first residue number
df = df.sort_index(key=lambda x: x.map(extract_first_residue_number))

# Create a heatmap
plt.figure(figsize=(12, 8))
sns.heatmap(df, cmap='YlGnBu', cbar=True, linewidths=0, cbar_kws={"ticks": [0, 10]})

# Add labels and title
plt.xlabel("Time (ns)")
plt.ylabel("Residues")
plt.title("Contacts (3 Angstrom) over time")
x_ticks = list(range(0, df.shape[1], 5))  # Generate ticks at intervals of 5
plt.xticks(ticks=x_ticks, labels=x_ticks)

# Customize X-axis ticks
ax = plt.gca()  # Get current axis
ax.xaxis.set_major_locator(MultipleLocator(5))  # Major ticks every 5
ax.xaxis.set_minor_locator(MultipleLocator(1))   # Minor ticks every 1
ax.tick_params(which='major', length=10, color='black')  # Major tick size and color
ax.tick_params(which='minor', length=5, color='gray')    # Minor tick size and color

# Save the plot
output_file = "heatmap.png"
plt.tight_layout()
plt.savefig(output_file, dpi=300)
print(f"Heatmap saved as '{output_file}'")

