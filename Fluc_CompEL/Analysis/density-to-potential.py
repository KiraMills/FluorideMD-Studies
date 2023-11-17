# Import the required libraries
import pandas as pd
import numpy as np
import scipy.integrate

# Prompt the user to enter the input data file name and the output file name
input_file_name = input("Please enter the name of the input data file (e.g., 'charge-density.dat'): ")
output_file_name = input("Please enter the name for the output CSV file (e.g., 'output_potential.csv'): ")

# Define a function to calculate the electrostatic potential
def calculate_potential(positions, charge_density, is_periodic=False):
    """
    Calculate the electrostatic potential from charge density by double integration
    of Poisson's equation in one dimension.

    Parameters:
    positions (array): Positions in Angstroms (numpy array).
    charge_density (array): Charge densities in e/Angstrom^3 (numpy array).
    is_periodic (bool): If True, make the potential periodic at the boundaries.

    Returns:
    array: Electrostatic potential at each position (numpy array).
    """

    # Epsilon_0 factor conversion to appropriate units
    epsilon_0_factor = 8.854e-12 / 1.602e-19 * 1e-10

    # Perform the first integration over charge density
    first_integration = scipy.integrate.cumtrapz(charge_density, positions, initial=0)

    # Perform the second integration to find the potential
    potential = -scipy.integrate.cumtrapz(first_integration, positions, initial=0) / epsilon_0_factor

    # Adjust the potential for periodic boundary conditions if needed
    if is_periodic:
        boundary_adjustment = ((potential[-1] - potential[0]) / (positions[-1] - positions[0]))
        potential -= boundary_adjustment * (positions - positions[0]) + potential[0]

    return potential

# Read the input data file, skipping the first row of header information
charge_density_data = pd.read_csv(input_file_name, delim_whitespace=True, skiprows=1, header=None, names=['Z', 'sd', 'error'])

# Extract the position and charge density from the data
positions = charge_density_data['Z'].values
charge_density = charge_density_data['sd'].values / 11290.81246  # Example normalization

# Calculate the electrostatic potential
electrostatic_potential = calculate_potential(positions, charge_density)

# Print the calculated potential
print(electrostatic_potential)

# Save the coordinate and potential data to a CSV file
output_data = pd.DataFrame({"coordinate": positions, "potential": electrostatic_potential})
output_data.to_csv(output_file_name, index=False)

print(f"Electrostatic potential data saved to {output_file_name}")
