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

OUT_R1="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.r1.fastq";
OUT_R2="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.r2.fastq";
OUT_SINGLETONS="ovolvulus_cleanseqs_addslash2.high-kmer-reads.repaired.singletons.fastq";
SINGLETONSNAMES="singletons_names.txt"
READS1="oncho_smansoni_human_addslash_aln_v2.sam.bam.r1.fastq"
READS2="oncho_smansoni_human_addslash_aln_v2.sam.bam.r2.fastq"
LIST="singletons_names_allpairs.txt"
LISTF="singletons_names_forward.txt"
LISTR="singletons_names_reverse.txt"
LISTFFIX="singletons_names_forward_fixed.txt"
LISTRFIX="singletons_names_reverse_fixed.txt"
FQF="singletons_forward.fq"
FQR="singletons_reverse.fq"
R1WS="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r1.fastq"
R2WS="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r2.fastq"
PREFIX=`basename $READS1 .r1.fastq.gz`; 
echo "PREFIX = $PREFIX";

# Step00: grep list of read names from singletons file
echo;echo "######################################################";
echo "Step00: grep list of read names from singletons file: `date`";echo;
CMD="grep "@ERR" $OUT_SINGLETONS > $SINGLETONSNAMES"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step01: Use resulting list along with a python script to create a list of sequences to extract from oncho_smansoni_human_aln.sam.bam.r 1 and 2
echo;echo "######################################################";
echo "Step01: Use resulting list along with a python script to create a list of sequences to extract from oncho_smansoni_human_aln.sam.bam.r 1 and 2: `date`";echo;
CMD="python add_singleton_pairs.py";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Python script contents: If the sequence name ends with /1, add a line underneath with the same name but ending in /2
# Else, if the sequence name ends with /2, add a line underneath with the same name but ending in /1
# Finish

# Step02: Separate reads into forward and reverse
echo;echo "######################################################";
echo "Step02: Separate reads into forward and reverse: `date`";echo;
CMD="grep "/1$" $LIST > $LISTF";
CMD="grep "/2$" $LIST > $LISTR";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step03: Use Seqtik to extract paired end sequences from interleaved file
## Remove "@" from read names
CMD="cut -c 2- $LISTF > $LISTFFIX"
CMD="cut -c 2- $LISTR > $LISTRFIX"
## Run seqtk command
echo;echo "######################################################";
echo "Extract reads using read names: forward `date`";echo;
CMD="seqtk subseq $READS1 $LISTF > $FQF";
echo;echo "Running: $CMD [`date`]";eval ${CMD};
echo;echo "######################################################";
echo "Extract reads using read names: reverse `date`";echo;
CMD="seqtk subseq $READS2 $LISTR > $FQR";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step04: Combine new fastq files with old fastq files
echo;echo "######################################################";
echo "Step04: Combine new fastq files with old fastq files: `date`";echo;
CMD="cat $FQF $OUT_R1 > $R1WS"
CMD="cat $FQR $OUT_R2 > $R2WS"
echo;echo "Running: $CMD [`date`]";eval ${CMD};







