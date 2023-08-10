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

CDHITCONTIGS="oncho_biomarkers/PRJNA289926/trinity/Step5_Subset/1_Extract_Nematoda_Platyhelminthes/PRJNA289926_trinity_cdhit95_contigs_nema_platy.fq"
LIST="PRJNA289926_trinity_cdhit95_kraken2_contigs_noloaloahits.txt"

echo;echo "######################################################";
echo "Extract reads using read names: forward `date`";echo;
CMD="seqtk subseq $CDHITCONTIGS $LIST > PRJNA289926_trinity_cdhit95_contigs_noloahits.fq"
echo;echo "Running: $CMD [`date`]";eval ${CMD};



echo "DONE: `date`";
############### END OF SCRIPT #################################