#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe smp 24 
# To get an e-mail when the job is done:
#$ -m e
#$ -M useremail@useraddress
# Long-running jobs (>30 minutes) should be submitted with:
#$ -q long.q
# export all environment variables to SGE
#$ -V

conda activate kraken2

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

NUMCPU=24;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU

DBNAME="krakenDB_ncbi_nt_2021_13-10";
CONTIGS="oncho_cleanseqs_addslash_withsingletons.cdhit95";
PREFIX=`basename $CONTIGS .cdhit95`;
echo "prefix=$PREFIX";
OUTPUT_FULL=$PREFIX".kraken2";
OUTPUT_REPORT=$PREFIX".kraken2report";

# Run Kraken2 to assign taxonomy information to the contigs
CMD="kraken2 --db $DBNAME --threads $NUMCPU --use-names --report $OUTPUT_REPORT --output $OUTPUT_FULL $CONTIGS";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE: `date`";
############### END OF SCRIPT #################################

