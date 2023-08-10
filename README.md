# Pipeline description and scripts used for an *Onchocerca volvulus* biomarker discovery project
- Description of pipelines and scripts used for analyzing publicly available metagenomic datasets and nanopore-sequenced amplicons.
- The scripts described here were run on an SGE / Grid Engine via qsub.
- All required software was installed using conda under various environments.

## Authors:
- Sofia Roitman (New England Biolabs, Ipswich, MA, US)

## Processing pipeline for NCBI metagenome data: Cleaning dataset and identifying candidate sequences
Metagenomic contigs were not aligned to the *Onchocerca volvulus* genome to allow for the identification of potential repeats/sequences that may not be present in the published genome.

### Step 1: Align metagenome data to reference genomes to remove contaminants
- Script: job001-bwa-align-smansoni.sh
- A list of what this script does, in order of operation:
  - Assign variables.
  - Step00: Index the *S. mansoni* genome
  - Step01: Align forward and reverse reads to the *S. mansoni* genome
  - Step02: Convert alignment file to bam
  - Step03: Sort, then discard the mapped reads and get only the UN-MAPPED reads from the bam file

- Script: job001-bwa-align-smansoni.sh
- A list of what this script does, in order of operation:
  - Assign variables.
  - Step00: Index the human genome
  - Step01: Align forward and reverse reads to the *S. mansoni* genome
  - Step02: Convert alignment file to bam
  - Step03: Sort, then discard the mapped reads and get only the UN-MAPPED reads from the bam file

### Step 2: K-mer counting and identifying enriched k-mers
- Script: job003-addslash.sh
  - Adds /1 or .2 to the names of the paired reads; necessary for the following steps.

- Script: job004-jellyfish.sh
- A list of what this script does, in order of operation:
  - Assign variables.
  - Step00: Unzip read files
  - Step01: Count k-mers
  - Step02: Compute a histogram of k-mer occurrences
  - Step03: Create a file of enriched k-mers
  - Step04: Zip read files

- Script: job005-fishoutwithbait.sh
  - Use python script fish_out_with_bait.py to fish out high-frequency k-mers from metagenome dataset. Python script was written by Laurence Ettwiler and is not included here as it has not been made publicly available by the owner.

- Script: job006-repair-reads.sh
  - Repairs high-kmer read file

### Step 3: Add singletons file back into the dataset
The result of step 2 is 3 files: a set of paired end read files and a singletons file. The singletons file contains all the sequences for which a high-frequency k-mer was identified, but only in that read, not its pair. Since this file contains about 30% of our reads, we don't want to throw it away; we want to grab the pairs of these singletons and incorporate them into the paired-end read files.

- Script: job007-add-singletons.sh
- A list of what this script does, in order of operation:
  - Assign variables.
  - Step00: grep list of read names from singletons file
  - Step01: Use resulting list along with a python script to create a list of sequences to extract from oncho_smansoni_human_aln.sam.bam.r 1 and 2
  - Step02: Separate reads into forward and reverse
  - Step03: Use Seqtik to extract paired-end sequences from interleaved file
  - Step04: Combine new fastq files with old fastq files

### Step 4: Run the Trinity assembler
- Script: job008-trinity.sh

### Step 5: Run CDHit
Clustered Trinity contigs at 95% similarity.
- Script: job009-cdhit-95.sh

### Step 6: Assign taxonomy to the contigs using Kraken2
- Script: job010-kraken2s.sh

### Step 7: Remove contaminants (reprise)
Here we extract contigs that belong to the phyla we are interested, and then we remove contigs that align to other filarial nematode species that are closely related or endemic to the same areas as our target, *Onchocerca volvulus*. We also remove contigs that align with the established biomarker for this species, O-150, as well as contigs that align with *O. volvulus* mitochondrial sequences.

#### Extract reads belonging to Nematoda and Platyhelminthes
- Script: job011-extract-nemaplaty.sh and extract_taxids_only_nema_platy.py
- A list of what this script does, in order of operation:
  - Python script uses lists containing all of the taxonomy IDs from species that belong to the phyla Nematoda and Platyhelminthes to create a list of contigs that belong to those phyla and should be kept in the dataset.
  - Run seqtk using the list output by the python script to extract the Nematoda and Platyhelminthes contigs from the contigs file.
 
#### Remove *Loa loa* contigs
- Script: job012-extract-noloahits.sh and remove-loaloahits.py
- A list of what this script does, in order of operation:
  - Python script uses a list containing the taxonomy ID for *Loa loa* to create a list of contigs that were not assigned as *Loa loa* and should be kept in the dataset.
  - Run seqtk using the list output by the python script to extract the contigs with no *Loa loa* hits from the contigs file.

#### Remove *Onchocerca ochengi* contigs
- Script: job013-extract-noochengihits.sh and remove-ochengihits.py
- Same as above, this time for *Onchocerca ochengi*

#### Remove O-150 contigs and mitochondria
- Script: job014-blast-O150-and-mito.sh, remove-O-150-mito.py, and job015-extract-noO150mito.sh
- Same as above, however first running a BLAST search of O-150 and mitochondrial sequences against our contigs to retrieve a list of contigs that must be removed.

### Step 8: Extract contigs with high lengths and coverage




