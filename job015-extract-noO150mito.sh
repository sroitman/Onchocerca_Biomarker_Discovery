#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -pe smp 8 
# To get an e-mail when the job is done:

#$ -m e
#$ -M sroitman@neb.com

#
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

CDHITCONTIGS="PRJNA289926_trinity_cdhit95_contigs_noloa_noochengi.fq"
LIST="RJNA289926_trinity_cdhit95_contigs_noloaochengiO150mito.txt"

echo;echo "######################################################";
echo "Extract reads using read names: forward `date`";echo;
CMD="seqtk subseq $CDHITCONTIGS $LIST > PRJNA289926_trinity_cdhit95_contigs_noloaochengiO150mito.fq"
echo;echo "Running: $CMD [`date`]";eval ${CMD};



echo "DONE: `date`";
############### END OF SCRIPT #################################