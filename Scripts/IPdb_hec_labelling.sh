#!/bin/bash

## After R procesing and Obtaining Q99 file with Top expresede 1% of pIRNA with his total norm reads
# for each piRNA at database, search in Q99 if exist add "hec" label

# Steps
# 	- Get hec sequences (from ReadNormalization.R) and Non hec sequences (from GetNonHec.R)
#		- Harmonize formats
#	 	- Merge files
#	 	- Sort and Compress

## Get sequences

dbName=IPdb_v2
Q99=/home/Odei/IPdb2/Extracting_ds_reads/Q99_piRNAs

cd /home/Odei/IPdb2/Extracting_ds_reads/tmp

# Get hec piRNAs and add "hec" label

cat $Q99 | sort -V  | grep "piR-mmu-*" |  while read piRNA extra TotReads; do
	sed "s/$piRNA|/$piRNA|hec|/1" $dbName.all.def.fa | grep -w -A1 -m 1 $piRNA >> tmp_hec_piRNAs.fa
done

# get no hec piRNAs
gunzip -c IPdb2_no_hec.fa.gz  >> IPdb2_hec_complete

# 2) Merge files

cat tmp_hec_piRNAs.fa | tr '\n' '\t' | tr '>' '\n' | sed 's/[ATGC] [ATGC]//g' | sed 's/^/>/g' | sed '1d' | awk -F'[\t|]' '{print $1"|"$2"\n"$4}' >> IPdb2_hec_complete

# 3) Sort fasta sequences and compress

seqkit sort -N -i --two-pass IPdb2_hec_complete > IPdb2_hec_complete_sorted
gzip IPdb2_hec_complete_sorted
