#!/bin/bash
set -o errexit

source activate phyluce-1.7.3

MY_CONFIG="/home/fernanda/2024_UCEs_USP183203/0_codes_and_conf_UCEs24/conf_spades_aula.conf" # My configuration file
OUTPUT_DIR="/home/fernanda/2024_UCEs_USP183203/3_assembly_spades" # My output directory
LOG_DIR="/home/fernanda/2024_UCEs_USP183203/log" # Path to log files

function main {
	printf "> START Assembly Spades: `date`\n"
	phyluce_assembly_assemblo_spades  \
		--config ${MY_CONFIG} \
		--output ${OUTPUT_DIR} \
		--cores 64 \
		--memory 122 \
		--log-path ${LOG_DIR}
	wait
	printf "> END Assembly Spades: `date`\n"
}

main

conda deactivate

exit