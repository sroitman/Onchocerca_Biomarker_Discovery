#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe smp 8 
# To get an e-mail when the job is done:
#$ -m e
#$ -M useremail@useraddress
# Long-running jobs (>30 minutes) should be submitted with:
#$ -q long.q
# export all environment variables to SGE
#$ -V

conda activate oncho_primers

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
################################################
cat $0;
################################################


NUMCPU=8;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU
DB="trinity_cdhit95_contigs_noloa_noochengi.fq"
NT_DB="/path/to/ncbi/nucleotide/db/nt"
INPUT1="O-150.fasta";
OUTPUT1="O150_vs_noloa_noochengi_db_results.txt"
INPUT2="Ov_mitochondrion_AF015193.1.txt"
OUTPUT2="AF015193.1_vs_noloa_noochengi_db_results.txt"
INPUT3="Ov_mitochondrion_KT599912.1.txt"
OUTPUT3="KT599912.1_vs_noloa_noochengi_db_results.txt"
INPUT4="Ov_mitochondrion_NC_001861.1.txt"
OUTPUT4="NC_001861.1_vs_noloa_noochengi_db_results.txt"

# Use our contig file as a database
CMD='makeblastdb -in $DB -dbtype nucl'; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# BLAST O-150 against our database
CMD='blastn -query $INPUT1 -db $DB -out $OUTPUT1'; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# BLAST Ov mitochondrial sequence against our database
CMD='blastn -query $INPUT2 -db $DB -out $OUTPUT2'; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# BLAST Ov mitochondrial sequence against our database
CMD='blastn -query $INPUT3 -db $DB -out $OUTPUT3'; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# BLAST Ov mitochondrial sequence against our database
CMD='blastn -query $INPUT4 -db $DB -out $OUTPUT4'; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE `date`";
##################### END OF SCRIPT ###############################################

