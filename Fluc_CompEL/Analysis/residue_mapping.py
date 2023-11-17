# Prompt the user for the input and output file names
input_file_name = input("Please enter the name of the input data file (e.g., 'FCount.dat'): ")
range_output_file_name = input("Please enter the name for the output file with frame ranges (e.g., 'frame_ranges.txt'): ")
full_output_file_name = input("Please enter the name for the output file with the full frame list (e.g., 'frame_full.txt'): ")

# Create dictionaries to store the mapping of residue numbers to frame numbers
residue_range_mapping = {}
residue_full_mapping = {}

# Read and process the input file
with open(input_file_name, 'r') as infile:
    for line in infile:
        values = line.strip().split()
        if len(values) >= 3:
            frame_number = int(values[0])
            num_f_ions = int(values[1])  # Unused variable 'num_f_ions', consider removing if not needed
            residue_numbers = [int(val) for val in values[2:]]

            # Iterate through residue numbers and update the mappings
            for residue_number in residue_numbers:
                if residue_number not in residue_range_mapping:
                    residue_range_mapping[residue_number] = []
                    residue_full_mapping[residue_number] = []
                residue_range_mapping[residue_number].append(frame_number)
                residue_full_mapping[residue_number].append(frame_number)

# Write the mapping with frame ranges to the range output file
with open(range_output_file_name, 'w') as range_outfile:
    for residue_number, frame_numbers in sorted(residue_range_mapping.items()):
        frame_ranges = []
        start_frame = frame_numbers[0]
        end_frame = frame_numbers[0]

        for frame in frame_numbers[1:]:
            if frame == end_frame + 1:
                end_frame = frame
            else:
                if start_frame == end_frame:
                    frame_ranges.append(str(start_frame))
                else:
                    frame_ranges.append(f"{start_frame}-{end_frame}")
                start_frame = end_frame = frame

        if start_frame == end_frame:
            frame_ranges.append(str(start_frame))
        else:
            frame_ranges.append(f"{start_frame}-{end_frame}")

        range_outfile.write(f"Residue {residue_number}: Frame Ranges ({', '.join(frame_ranges)})\n")

# Write the mapping with full frame list to the full output file
with open(full_output_file_name, 'w') as full_outfile:
    for residue_number, frame_numbers in sorted(residue_full_mapping.items()):
        full_outfile.write(f"Residue {residue_number}: Frame List ({', '.join(map(str, frame_numbers))})\n")

print(f"Frame ranges saved to {range_output_file_name}")
print(f"Full frame list saved to {full_output_file_name}")
