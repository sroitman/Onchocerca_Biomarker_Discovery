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

conda activate samtoolsbamba

set -ue;

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
echo "Job is:"
################################################
cat $0;
################################################

NUMCPU=8;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU
IN_BAM="oncho_smansoni_aln.sam.bam";
IN_SAM="oncho_smansoni_aln.sam"
OUT_PREFIX=`basename $IN_BAM .aligned.sorted.bam`;
SMANSONIGENOME="path/to/genome/smansoni_genome.fna"
READ1="oncho_biomarkers/ncbi_r1.fq "
READ2="oncho_biomarkers/ncbi_r2.fq"
R1=$OUT_PREFIX".r1.fastq";
R2=$OUT_PREFIX".r2.fastq";
SINGLES=$OUT_PREFIX".singletons.fastq";

# Step 00: Index the S. mansoni genome
echo;echo "######################################################";
echo "Step 00: Index the S. mansoni genome: `date`";echo;
CMD="bwa index $SMANSONIGENOME";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 01: Align processed forward and reverse reads to the S. mansoni genome
echo;echo "######################################################";
echo "Step 01: Align processed forward and reverse reads to the S. mansoni genome: `date`";echo;
CMD="bwa mem -t $NUM_THREADS $SMANSONIGENOME $READ1 $READ2 > $IN_SAM";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 02: Convert alignment file to bam
echo;echo "######################################################";
echo "Step 02: Convert alignment file to bam: `date`";echo;
CMD="samtools view -h -b -S $IN_SAM > $IN_BAM";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

# Step 03: Sort, then discard the mapped reads and get only the UN-MAPPED reads from the bam file
echo;echo "######################################################";
echo "Step 03: Sort, then discard the mapped reads and get only the UN-MAPPED reads from the bam file: `date`";echo;
CMD="samtools sort -n --threads $NUM_THREADS $IN_BAM |samtools view -h -f 4 | samtools fastq --threads $NUM_THREADS -1 $R1 -2 $R2 -s $SINGLES";
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "DONE: `date`";echo;
############### END OF SCRIPT #################################