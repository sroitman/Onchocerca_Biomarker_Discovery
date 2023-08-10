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

echo "Running script $0 on `hostname`"
echo "Job is:"
################################################"
cat $0;
echo "pwd = `pwd`";
################################################"

CDHITCONTIGS="trinity_cdhit95_contigs_noloaochengiO150mito.fq"
LIST="trinity_cdhit95_noloaochengiO150mito_rmapmin2500.txt"
RMAPMIN2500="trinity_cdhit95_contigs_noloaochengiO150mito_rmapmin2500.fq"

echo;echo "######################################################";
echo "Extract contigs with a minimum read mapping number of 2500 `date`";echo;
CMD="seqtk subseq $CDHITCONTIGS $LIST > $RMAPMIN2500"
echo;echo "Running: $CMD [`date`]";eval ${CMD};



echo "DONE: `date`";
############### END OF SCRIPT #################################