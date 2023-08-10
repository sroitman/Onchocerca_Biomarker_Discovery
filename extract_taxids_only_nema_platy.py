#!/usr/bin/python
import pandas as pd


##### PLATY

# Read in dataframe
df = pd.read_csv('trinity_cdhit95_kraken2_wcolumnnames.txt', sep="\t")

# Read in the list of IDs as a list
my_file = open("path/to/platyhelminthes/taxids/6157.taxid.txt", "r")
content = my_file.read()
content_list = content.split("\n")

# Split the tax column to get access to the ID number. Start by splitting at the first parentheses
df_test = pd.concat([df['contig_id'], df['tax'].str.split('(', expand=True)], axis=1)

## Second parentheses
df_test2 = pd.concat([df['contig_id'], df_test[1].str.split(')', expand=True)], axis=1)

## Replace the word "taxid" with nothing. Result: file containing a column of contig names, and a column with the tax ID
df_test3 = pd.concat([df['contig_id'], df_test2[0].str.replace('taxid ','')], axis=1)

## Print dataframe for which the tax ID does not match to the list of IDs - the list of IDs is for all arthropods, which we are trying to exclude from the final file.
print(df_test3.loc[df_test3[0].isin(content_list)])

## Export dataframe as csv
df_final = df_test3.loc[df_test3[0].isin(content_list)]
df_final['contig_id'].to_csv(r'/trinity_cdhit95_kraken2_contigs_platy.csv', index = False)


##### NEMA
df = pd.read_csv('trinity_cdhit95_kraken2_wcolumnnames.txt', sep="\t")

# Read in the list of IDs as a list
my_file = open("/path/to/nematoda/taxids/6231.taxid.txt", "r")
content = my_file.read()
content_list = content.split("\n")

# Split the tax column to get access to the ID number. Start by splitting at the first parentheses
df_test = pd.concat([df['contig_id'], df['tax'].str.split('(', expand=True)], axis=1)

## Second parentheses
df_test2 = pd.concat([df['contig_id'], df_test[1].str.split(')', expand=True)], axis=1)

## Replace the word "taxid" with nothing. Result: file containing a column of contig names, and a column with the tax ID
df_test3 = pd.concat([df['contig_id'], df_test2[0].str.replace('taxid ','')], axis=1)

## Print dataframe for which the tax ID does not match to the list of IDs - the list of IDs is for all arthropods, which we are trying to exclude from the final file.
print(df_test3.loc[df_test3[0].isin(content_list)])

## Export dataframe as csv
df_final = df_test3.loc[df_test3[0].isin(content_list)]
df_final['contig_id'].to_csv(r'trinity_cdhit95_kraken2_contigs_nema.csv', index = False)


