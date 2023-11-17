import csv

# Prompt the user for file names and search parameters
frames_file_name = input("Enter the name of the file containing the F frames (e.g., 'frame_full.txt'): ")
data_file_name = input("Enter the name of the input data file (e.g., 'Fwater.dat'): ")
residue_number = int(input("Enter the residue number (e.g., 2120): "))
column_header = input("Enter the column header to search for (e.g., 'F2120[lower]' or 'F2120[UU]'): ")
output_file_name = input("Enter the name for the output data file (e.g., 'F2120_Fwater.csv'): ")

# 1. Extract frames for the specified residue
def extract_frames_for_residue(filename, residue):
    with open(filename, 'r') as f:
        for line in f:
            if line.startswith(f"Residue {residue}:"):
                # Extract numbers between parentheses
                frame_list_str = line.split("(")[1].split(")")[0]
                return [int(frame.strip()) for frame in frame_list_str.split(",")]

frames = extract_frames_for_residue(frames_file_name, residue_number)

# 2. & 3. Extract data for the specified atom for the frames extracted above
def extract_data_for_frames(data_filename, atom_name, frames_list):
    with open(data_filename, 'r') as f:
        header = f.readline().strip().split()  # Read the header
        if atom_name not in header:
            raise ValueError(f"{atom_name} not found in data file header!")

        col_index = header.index(atom_name)
        relevant_data = {}

        for line_number, line in enumerate(f, start=1):  # Start counting lines from 1
            if line_number in frames_list:  # Check if the line_number matches a frame from our list
                data = line.strip().split()
                relevant_data[line_number] = float(data[col_index])  # Convert to float since it's numerical data

        return relevant_data

data_for_residue = extract_data_for_frames(data_file_name, column_header, frames)

# Writing to a CSV
def write_to_csv(data_dict, output_filename):
    with open(output_filename, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(["#Frame", column_header])  # header
        for frame, value in data_dict.items():
            csvwriter.writerow([frame, value])

write_to_csv(data_for_residue, output_file_name)

print(f"Data for residue {residue_number} with header '{column_header}' has been written to {output_file_name}")
