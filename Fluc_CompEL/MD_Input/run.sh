#!/bin/bash

#SBATCH -J job-name           # Job name
#SBATCH -o job.%j.out         # Name of stdout output file (%j expands to jobId)
#SBATCH -N 1                  # Total number of nodes requested
#SBATCH -n 1                  # Total number of mpi tasks requested
#SBATCH -t 48:00:00           # Run time (hh:mm:ss) - 48 hours
#SBATCH -p partition-name
#SBATCH --mail-user=email_address
#SBATCH --mail-type=all


##Source amber and any packages needed for it to run 


#Run the stepwise heating, where each step has the run command: 
#pmemd.cuda -O -i input_file -o output_file -p prmtop -c starting_coords -r restart_file -ref ref_coords_for_restraints
pmemd.cuda -O -i 01_Min1.in -o 01_Min1.out -p NAME.prmtop -c NAME.inpcrd -r 01_Min1.rst -ref NAME.inpcrd
pmemd.cuda -O -i 02_Min2.in -o 02_Min2.out -p NAME.prmtop -c 01_Min1.rst -r 02_Min2.rst -ref 01_Min1.rst
pmemd.cuda -O -i 03_Min3.in -o 03_Min3.out -p NAME.prmtop -c 02_Min2.rst -r 03_Min3.rst -ref 02_Min2.rst


#Run the heating steps, where each step has the run command: 
#pmemd.cuda -O -i input_file -o output_file -p prmtop -c starting_coords -r restart_file -ref ref_coords_for_restraints -x trajectory_file
pmemd.cuda -O -i 04_Heat1.in -o 04_Heat1.out -p NAME.prmtop -c 03_Min3.rst -r 04_Heat1.rst -ref 03_Min3.rst -x 04_Heat1.nc
pmemd.cuda -O -i 05_Heat2.in -o 05_Heat2.out -p NAME.prmtop -c 04_Heat1.rst -r 05_Heat2.rst -ref 04_Heat1.rst -x 05_Heat2.nc


#Run the equilibration steps, for membranes/membrane proteins it's standard to do 10 x 500 ps steps, where each step has the run command: 
#pmemd.cuda -O -i input_file -o output_file -p prmtop -c starting_coords -r restart_file -ref ref_coords_for_restraints -x trajectory_file
pmemd.cuda -O -i 06_Hold.in -o 06_Hold1.out -p NAME.prmtop -c 05_Heat2.rst -r 06_Hold1.rst -ref 05_Heat2.rst -x 06_Hold1.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold2.out -p NAME.prmtop -c 06_Hold1.rst -r 06_Hold2.rst -ref 06_Hold1.rst -x 06_Hold2.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold3.out -p NAME.prmtop -c 06_Hold2.rst -r 06_Hold3.rst -ref 06_Hold2.rst -x 06_Hold3.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold4.out -p NAME.prmtop -c 06_Hold3.rst -r 06_Hold4.rst -ref 06_Hold3.rst -x 06_Hold4.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold5.out -p NAME.prmtop -c 06_Hold4.rst -r 06_Hold5.rst -ref 06_Hold4.rst -x 06_Hold5.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold6.out -p NAME.prmtop -c 06_Hold5.rst -r 06_Hold6.rst -ref 06_Hold5.rst -x 06_Hold6.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold7.out -p NAME.prmtop -c 06_Hold6.rst -r 06_Hold7.rst -ref 06_Hold6.rst -x 06_Hold7.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold8.out -p NAME.prmtop -c 06_Hold7.rst -r 06_Hold8.rst -ref 06_Hold7.rst -x 06_Hold8.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold9.out -p NAME.prmtop -c 06_Hold8.rst -r 06_Hold9.rst -ref 06_Hold8.rst -x 06_Hold9.nc
pmemd.cuda -O -i 06_Hold.in -o 06_Hold10.out -p NAME.prmtop -c 06_Hold9.rst -r 06_Hold10.rst -ref 06_Hold9.rst -x 06_Hold10.nc


#Run the production steps, repeat this as many times as needed to get useful information, where each step has the run command: 
#pmemd.cuda -O -i input_file -o output_file -p prmtop -c starting_coords -r restart_file -ref ref_coords_for_restraints -x trajectory_file
pmemd.cuda -O -i 07_Prod.in -o 07_Prod1.out -p NAME.prmtop -c 06_Hold10.rst -r 07_Prod1.rst -ref 06_Hold10.rst -x 07_Prod1.nc
pmemd.cuda -O -i 07_Prod.in -o 07_Prod2.out -p NAME.prmtop -c 07_Prod1.rst -r 07_Prod2.rst -ref 07_Prod1.rst -x 07_Prod2.nc
pmemd.cuda -O -i 07_Prod.in -o 07_Prod3.out -p NAME.prmtop -c 07_Prod2.rst -r 07_Prod3.rst -ref 07_Prod2.rst -x 07_Prod3.nc
