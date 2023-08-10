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

conda activate trinity_env

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

NUMCPU=16;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU

R1WS="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r1.fastq"
R2WS="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r2.fastq"

echo;echo "######################################################";
CMD="Trinity --seqType fq --left $R1WS --right $R2WS --no_bowtie --CPU 16 --max_memory 32G";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE: `date`";
############### END OF SCRIPT #################################
