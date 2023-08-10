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

conda activate jellyfish

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

READS1="oncho_smansoni_human_addslash_aln_v2.sam.bam.r1.fastq"
READS2="oncho_smansoni_human_addslash_aln_v2.sam.bam.r2.fastq"
OUTPUT="oncho_cleanseqs_addslash.jfish"
ENRICHED_MOTIF="oncho_cleanseqs_addslash_enriched_motif"
OUTPUT_HISTO=`basename $OUTPUT .jfish`".histo";
echo $OUTPUT_HISTO;
#OUTPUT_HISTO=$OUTPUT_HISTO".histo"
KMER_LEN=21
NUMCPU=16
HASH_SIZE=10000000000
LOWEST_COUNT=2


# Step 00: Unzip read files
echo;echo "######################################################";
echo "Step 00: Unzip files";date;
CMD="unpigz $READS1";
CMD="unpigz $READS2";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

READS1=`basename $READS1 .gz`;
READS2=`basename $READS2 .gz`;

# Step 01: Count k-mers
echo;echo "######################################################";
echo "Step 01: Count k-mers:";date;
CMD="jellyfish count -m $KMER_LEN -o $OUTPUT -s $HASH_SIZE -L $LOWEST_COUNT -t $NUMCPU $READS1 $READS2";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 02: Compute a histogram of k-mer occurrences
echo;echo "######################################################";
echo "Step 02: Compute a histogram of k-mer occurrences:";date;
CMD="jellyfish histo $OUTPUT -o $OUTPUT_HISTO";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 03: Create a file of enriched k-mers
echo;echo "######################################################";
echo "Step 03: Create a file of enriched k-mers:";date;
CMD="jellyfish dump -c $OUTPUT | perl -a -lne 'print "$F[0]\t$F[1]" if $F[1] > 1000' | perl -a -lne 'print "$F[0]\t$F[1]" if $F[1] < 100000' > $ENRICHED_MOTIF";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 04: Zip read files
echo;echo "######################################################";
echo "Step 04: Zip read files:";date;
CMD="pigz $READS1";
CMD="pigz $READS2";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "DONE: `date`";echo;
############### END OF SCRIPT #################################