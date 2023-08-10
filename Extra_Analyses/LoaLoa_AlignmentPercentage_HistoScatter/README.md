Folder containing extra analyses conducted for the *Loa loa* contigs. 

First, we BLAST our contigs against *Loa loa*. We then extract the lengths of the contigs that aligned to *Loa loa* and import the BLAST result table along with the contig length table into R. 

In R, we calculate the alignment percentage for each contig (alignment length/length of the contig) and we create a histogram of the alignment percentages along with a scatterplot of the alignment % plotted against the identity %. 
