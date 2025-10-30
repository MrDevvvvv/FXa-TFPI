import os
import pandas as pd

# Define the root directory containing replicate_* folders
root_dir = os.getcwd()

# Initialize an empty list to store dataframes
dataframes = []

# Traverse through all replicate_* folders and find CSV files
for folder in os.listdir(root_dir):
    folder_path = os.path.join(root_dir, folder)
    if os.path.isdir(folder_path) and folder.startswith("replicate_"):
        print(folder_path)
        for file in os.listdir(folder_path):
            if file.endswith("contactResSer.csv"):
                file_path = os.path.join(folder_path, file)
                # Read the CSV file and append to the list
                df = pd.read_csv(file_path, delim_whitespace=True)
                print(f"Processing {file_path}, columns: {df.columns.tolist()}")
                dataframes.append(df)

# Merge the dataframes on the `#Frames` column, summing common columns
merged_df = pd.concat(dataframes).groupby("#Frame", as_index=False).sum()

# Save the result to a new CSV file
output_path = os.path.join(root_dir, "merged_result.csv")
merged_df.to_csv(output_path, index=False)

print(f"Merged CSV saved to: {output_path}")
