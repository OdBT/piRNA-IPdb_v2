# script to run afterParrallel run in order to analyze & nromalize all IPdb.v2 read data.

# Steps
# 	- Data input
#		- Data Normalization (by CPM)
#	 	- Calc Quantiles
#	 	- Write data

## Data input ##

IPdb_read_by_dataset <- read.table(file = "/home/Odei/IPdb2/Paralel/All_fi_sort.tsv",
                 header = TRUE,sep = "\t")

# print R object size
format(object.size(IPdb_read_by_dataset), units = "auto")

# Data preparation #

IPdb_read_by_dataset[is.na(IPdb_read_by_dataset)] <- 0 # quit NA values
IPdb_read_by_dataset$X217 <- NULL # quitar la falsa ds217
colnames(IPdb_read_by_dataset) <- c("ds5","ds11","ds12","ds13","ds31","ds32","ds33","ds34","ds35","ds36","ds37","ds38","ds60","ds61","ds72","ds81","ds82","ds87","ds88","ds132","ds133","ds134","ds217")
# IPdb_read_by_dataset$ds5 <- 1; IPdb_read_by_dataset$ds134 <- 1
IPdb_read_by_dataset$ds5 <- NULL; IPdb_read_by_dataset$ds134 <- NULL

## Data normalization by CPM ##

#calc colSums and divide by them
IPdb_read_by_dataset$tot <- NULL
IPdb_CPM <- round(sweep(IPdb_read_by_dataset,2,colSums(IPdb_read_by_dataset)/1000000,`/`),0)
#                  ^ sweep divides each col value for his colSum

# Add Total reads and sort
IPdb_CPM$tot <- rowSums(IPdb_CPM)
IPdb_CPM_sort <- IPdb_CPM[order(-IPdb_CPM$tot),]

IPdb_CPM_sort$Tcum <- cumsum(IPdb_CPM_sort[, "tot"])

# Calc some Quantile
quantile(IPdb_CPM_sort$tot,  probs = c(1,50,75,99,99.9,99.99999)/100)
# percentil 99 = 14 (te top 99% of reads had above 14 CPM)

# Save the top expressed 1%
Q99_piRNAs <- subset(x = IPdb_CPM_sort, subset = tot >= quantile(IPdb_CPM_sort$tot,0.99) )

dim(Q99_piRNAs) # +- 196 974 piRNAs at Q99

# write file with all piRNAs names
# delete
write.table(x = Q99_piRNAs[,21:22],file = "/home/Odei/IPdb2/Extracting_ds_reads/Q99_piRNAs"
            ,quote=FALSE,row.names = TRUE,col.names = FALSE)
