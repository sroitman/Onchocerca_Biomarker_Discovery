#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -l ram=256G 
# To get an e-mail when the job is done:
#$ -m e
#$ -M useremail@useraddress
# Long-running jobs (>30 minutes) should be submitted with:
#$ -q long.q
# export all environment variables to SGE
#$ -V

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

NUMCPU=4;
let "NUM_THREADS=$NUMCPU * 2"; # Use MAX= 4X of $NUMCPU

IN_BROKEN="ovolvulus_cleanseqs_addslash.high-kmer-reads.fq"

OUT_R1="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.r1.fastq";
OUT_R2="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.r2.fastq";

OUT_SINGLETONS="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.singletons.fastq";

# Repair high-kmer read file.
echo;echo "######################################################";
CMD="repair.sh in=$IN_BROKEN out1=$OUT_R1 out2=$OUT_R2 outs=$OUT_SINGLETONS repair";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE: `date`";
############### END OF SCRIPT #################################

