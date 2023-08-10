#!/usr/bin/python
import pandas as pd

# Read in dataframe
df = pd.read_csv('trinity_cdhit95_kraken2_contigs_noloahits.txt', sep="\t")

# Read in the list of IDs as a list
my_file = open("ochengi_contigids.txt", "r")
content = my_file.read()
content_list = content.split("\n")

## Export dataframe as csv
df_final = df.loc[df['contig_id'].isin(content_list) == False]
df_final.to_csv(r'trinity_cdhit95_contigs_noloahits_noochengihits.txt', index = False, sep = "\t")

