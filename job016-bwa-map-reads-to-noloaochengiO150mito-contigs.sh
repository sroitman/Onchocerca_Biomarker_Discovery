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

echo "Running script $0 on `hostname`";
echo "Running in folder `pwd`";
################################################
cat $0;
################################################


NUMCPU=8;
let "NUM_THREADS=$NUMCPU * 3"; # Use MAX= 4X of $NUMCPU
CONTIGS="trinity_cdhit95_contigs_noloaochengiO150mito.fq";
READ1="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r1.fastq"
READ2="withsingletons_cleanseqs_addslash2.high-kmer-reads.repaired.r2.fastq"
SAMFILE="trinity_cdhit95_contigs_noloaochengiO150mito_aln.sam"
SAMFILEBAM="trinity_cdhit95_contigs_noloaochengiO150mito_aln.sam.bam"
#SAMFILEBAMSORTED="cdhit95_contigs_reads_aln.sam.bam.sorted"
SAMFILEBAMSORTEDBAM="trinity_cdhit95_contigs_noloaochengiO150mito_aln.sam.bam.sorted.bam"
SAMFILEBAMSORTEDBAMIDX="trinity_cdhit95_contigs_noloaochengiO150mito_aln.sam.bam.sorted.bam.idxstats"
SAMFILEBAMSORTEDBAMCOUNTS="trinity_cdhit95_contigs_noloaochengiO150mito_aln.sam.bam.sorted.bam.counts"

echo;echo "######################################################";
echo "Index the contigs file `date`";echo;
CMD="bwa index $CONTIGS"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Map reads to contigs `date`";echo;
CMD="bwa mem $CONTIGS $READ1 $READ2 > $SAMFILE"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Index contigs file with samtools `date`";echo;
CMD="samtools faidx $CONTIGS"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Convert SAM file to BAM `date`";echo;
CMD="samtools view -h -b -S $SAMFILE > $SAMFILEBAM"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Convert SAM file to BAM `date`";echo;
CMD="samtools sort $SAMFILEBAM -o $SAMFILEBAMSORTEDBAM"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Convert SAM file to BAM `date`";echo;
CMD="samtools index $SAMFILEBAMSORTEDBAM"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Create file with counts of the total number of reads mapping to each contig `date`";echo;
CMD="samtools idxstats $SAMFILEBAMSORTEDBAM > $SAMFILEBAMSORTEDBAMIDX"
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo;echo "######################################################";
echo "Create file with counts of the total number of reads mapping to each contig `date`";echo;
CMD="cut -f1,3 $SAMFILEBAMSORTEDBAMIDX > $SAMFILEBAMSORTEDBAMCOUNTS
echo;echo "Running: $CMD [`date`]";eval ${CMD};

echo "DONE: `date`";
############### END OF SCRIPT #################################

