#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -l ram=32G 
# To get an e-mail when the job is done:
#$ -m e
#$ -M useremail@useraddress
# export all environment variables to SGE
#$ -V

conda activate oncho_primers

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

NUMCPU=16;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU

READ1="oncho_smansoni_human_aln_v2.sam.bam.r1.fastq"
READ2="oncho_smansoni_human_aln_v2.sam.bam.r2.fastq"
OUT1="oncho_smansoni_human_addslash_aln_v2.sam.bam.r1.fastq"
OUT2="oncho_smansoni_human_addslash_aln_v2.sam.bam.r2.fastq"

# Add /1 or .2 to the names of the paired reads; necessary
echo;echo "######################################################";
echo "Add /1 or .2 to the names of the paired reads; necessary `date`";echo;
CMD="reformat.sh in1=$READ1 in2=$READ2 out1=$OUT1 out2=$OUT2 addslash slashspace=f";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE: `date`";
############### END OF SCRIPT #################################