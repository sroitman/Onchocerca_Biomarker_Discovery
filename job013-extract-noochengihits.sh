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


set -ue;

echo "Running script $0 on `hostname`"
echo "Job is:"
################################################"
cat $0;
echo "pwd = `pwd`";
################################################"

CDHITCONTIGS="trinity_cdhit95_contigs_noloahits.fq"
LIST="trinity_cdhit95_contigs_noochengihits.txt"
NOOCH="trinity_cdhit95_contigs_noloa_noochengi.fq"

echo;echo "######################################################";
echo "Extract reads using read names: forward `date`";echo;
CMD="seqtk subseq $CDHITCONTIGS $LIST > $NOOCH"
echo;echo "Running: $CMD [`date`]";eval ${CMD};



echo "DONE: `date`";
############### END OF SCRIPT #################################