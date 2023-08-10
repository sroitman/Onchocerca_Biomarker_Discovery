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

CDHITOUT="oncho_cleanseqs_addslash_withsingletons.cdhit95";
LIST="contigs_nema_platy.txt"
FQNP="trinity_cdhit95_contigs_nema_platy.fq"

echo;echo "######################################################";
echo "Extract Nematoda and Platyhelminthes contigs `date`";echo;
CMD="seqtk subseq $CDHITCONTIGS $LIST > $FQNP"
echo;echo "Running: $CMD [`date`]";eval ${CMD};


echo "DONE: `date`";
############### END OF SCRIPT #################################








