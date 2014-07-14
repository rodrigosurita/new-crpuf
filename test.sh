#!/bin/bash

###########################################################################
#
#
#
#
###########################################################################

# GLOBAL PARAMETERS

# ModelSim installantion binaries
SimInstallDir="\/root\/altera\/13.0sp1\/modelsim_ase\/bin"

# PUF Parameters	
XORi="3"
XORj="3"

# Test Parameters
VectorWidth="6"	 # 2x XORi
VectorSize="16"
Devices="1000"
TimeBase="100"


echo "***************************"
echo "*    CRPUF Sim v2.0RC     *"
echo "***************************"

# Clean project
echo "Cleaning..."
make vsim-clean 

# Create Challanges and Delay
#xpython scripts/delaygen.py -d 'data/RPUF_delays/atrasos_RPUF_'$XORi'x'$XORj'_'$Devices'_pufs_.txt'  -c 'data/Challenges/desafios_'$VectorSize'_C_'$VectorWidth'_bits.txt' -i $XORi -j $XORj -n $Devices -v $VectorSize

echo "Seed Parameters..."
# Seed Paramaters all around the platform
sed -e "s/MATRIZ_I_GLOBAL/"$XORi"/g" vhdl/src/resources.vhd.in > vhdl/src/resources.vhd
sed -e "s/MATRIZ_J_GLOBAL/"$XORj"/g" vhdl/src/resources.vhd > vhdl/src/resources.vhd.temp
sed -e "s/VECTOR_SIZE_GLOBAL/"$VectorSize"/g" vhdl/src/resources.vhd.temp > vhdl/src/resources.vhd
sed -e "s/DEVICES_GLOBAL/"$Devices"/g" vhdl/src/resources.vhd > vhdl/src/resources.vhd.temp
sed -e "s/TIME_BASE_GLOBAL/"$TimeBase"/g" vhdl/src/resources.vhd.temp > vhdl/src/resources.vhd
sed -e "s/VSIM_DIR/"$SimInstallDir"/g" scripts/modelsim_do/create_idea_lib.do.in > scripts/modelsim_do/create_idea_lib.do
sed -e "s/VSIM_DIR/"$SimInstallDir"/g" scripts/modelsim_do/create_module.do.in > scripts/modelsim_do/create_module.do
sed -e "s/VSIM_DIR/"$SimInstallDir"/g" scripts/modelsim_do/simulate_tb.do.in > scripts/modelsim_do/simulate_tb.do

rm vhdl/src/resources.vhd.temp

# Simulate VHDL
echo "SIMULATE VHDL..."
make vsim
echo "Simulation Done!"

# Extract Signatures
python scripts/sign.py -i 'data/PUF_Response/RAW_response_PUF_'$XORi'x'$XORj'_bits_'$Devices'_pufs.txt' -o 'data/PUF_Response/Signature_PUF_'$XORi'x'$XORj'_bits_'$Devices'_pufs.txt' -t $TimeBase




