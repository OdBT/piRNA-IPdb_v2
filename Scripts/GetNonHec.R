###### Get non hec ###########
# script to compare two fasta files and write a fasta file with exclusive piRNAs
library(Biostrings)

## data input ##
# convert Q99 in pesudo fasta
system2(cat Q99_piRNAs |sort -V| awk 'F=" "{print ">"$1"\n""AAAA"}' > pseudoQ99.fasta)
# modify

IPdb.Complete = readAAStringSet("/media/zigoto/b39be7e1-873e-4177-8163-acd995c7c36e/Odei/BD/IPdb/IPdb_v2/Extracting_ds_reads/tmp/IPdb_v2.all.def.fa")
hec_list = readAAStringSet("/media/zigoto/b39be7e1-873e-4177-8163-acd995c7c36e/Odei/BD/IPdb/IPdb_v2/Extracting_ds_reads/tmp/pseudoQ99.fasta")

# checking
length(names(IPdb.Complete)); head (names(IPdb.Complete))
length(names(hec_list)); head (names(hec_list))

# Extract list of non hec piRNAs
No_hec_pi <- setdiff(names(IPdb.Complete),names(hec_list))
No_hec_piList <- data.frame(name = No_hec_piList)

selected_sequences <- IPdb.Complete[No_hec_piList$name]

# save to file
writeXStringSet(x = selected_sequences,filepath="/media/zigoto/b39be7e1-873e-4177-8163-acd995c7c36e/Odei/BD/IPdb/IPdb_v2/Extracting_ds_reads/tmp/IPdb2_no_hec.fa.gz",
                compress = TRUE, format="fasta")
