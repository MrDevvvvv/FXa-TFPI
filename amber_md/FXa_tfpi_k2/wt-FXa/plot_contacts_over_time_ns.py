import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import MultipleLocator

# Load the Dictionary.csv file using a semicolon as the delimiter
dictionary_df = pd.read_csv('~/Dictionary.csv', delimiter=';', header=None)

# Create a dictionary mapping the old header (first column) to the new header (second column)
dictionary = dict(zip(dictionary_df[0], dictionary_df[1]))

# Load the CSV file (ensure the path is correct)
df = pd.read_csv('merged_result.csv', delimiter=",")

# Remove '_GG2:236' from headers and modify them
#df.columns = df.columns.str.replace(r'_GG2:236', '', regex=True)
#modified_headers = [header.split('_')[0].replace(':', '_') for header in df.columns]
#df.columns = modified_headers

# Function to extract the numerical part for sorting
#def extract_number(header):
#    if header != '#Frame' and '_' in header:
 #       return int(header.split('_')[-1])  # Extract number after '_'
 #   return float('-inf')  # Ensure '#Frame' stays first

# Sort headers based on the extracted number
#sorted_headers = sorted(df.columns, key=extract_number)

# Reorder DataFrame columns based on sorted headers
#df = df[sorted_headers]

# Convert headers using the dictionary
#converted_headers = [dictionary.get(header, header) for header in sorted_headers]
#df.columns = converted_headers

# Set '#Frame' as index if it exists
if '#Frame' in df.columns:
    df.set_index('#Frame', inplace=True)
# Transpose the DataFrame for heatmap visualization
df = df.T

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

# Save the plot as a PNG file
output_file = "heatmap.png"
plt.tight_layout()
plt.savefig(output_file, dpi=300)
print(f"Heatmap saved as '{output_file}'")

