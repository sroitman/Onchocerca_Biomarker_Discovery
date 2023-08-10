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
################################################
cat $0;
################################################


NUMCPU=16;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU

QUERY="trinity_cdhit95_contigs_nema_platy.fq"
NT_DB="/path/to/ncbi/nucleotide/database/nt"
LOALOA="7209.taxid.txt"
LOALOAALN="trinity_cdhit95_nemaplaty_aln_LoaLoa.tab"

# Run a BLASTN search querying the contigs against Loa loa
echo;echo "######################################################";
CMD="blastn -db $NT_DB -query $QUERY -taxidlist 7209.taxid.txt -outfmt 7 -out $LOALOAALN";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE `date`";
##################### END OF SCRIPT ###############################################