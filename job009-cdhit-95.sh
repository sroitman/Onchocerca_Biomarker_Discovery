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

conda activate cdhit

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
################################################
cat $0;
################################################


NUMCPU=8;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU
IDENTITY=0.95;
INPUT="/path/to/Trinity.fasta";
GLOBAL=1;
CDHITOUT="oncho_cleanseqs_addslash_withsingletons.cdhit95";

# Run CDHIT; cluster to 95% identity
CMD="cd-hit-est -i $INPUT -o $CDHITOUT -T $NUMCPU -M 24000 -d 20 -n 10 -l 11 -r 1 -p 1 -c $IDENTITY"; 
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE `date`";
##################### END OF SCRIPT ###############################################
