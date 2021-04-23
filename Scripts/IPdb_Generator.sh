#!/bin/bash
# script that generates new IPdb from desired datasets of IPdb

# Steps
# 	- Download piRBase for mmu
#	- Extract IPdb datasets
#	- Merge All dataset sequences

outFolder=/home/Odei/IPdb2/Extracting_ds_reads
PerlFolder=/home/Odei/IPdb2/Scripts

mkdir -p $outFolder
cd $outFolder

## Download datasets ##
wget http://regulatoryrna.org/database/piRNA/download/archive/v2.0/data/piR_mmu.txt.gz -O $outFolder/piR_mmu.txt.gz
gunzip piR_mmu.txt.gz

## Extract datasets sequences and reads ##
dbName=IPdb_v2
data=/home/Odei/IPdb2/piR_mmu.txt

# cleaning
# rm -f $outFolder/$dbName
# rm -f $outFolder/Summary_reads_per_ds.txt
# rm -f $outFolder/IPdb_v2_reads.fasta


for datasetN in 5 11 12 13 31 32 33 34 35 36 37 38 60 61 72 81 82 87 88 132 133 134 217 
do
	echo "looking reads of $datasetN dataset"

if [ $datasetN == '5' ] || [ $datasetN == '134' ]  # these dataset have no known read data
then
	perl $PerlFolder/piRbase_seq_Extractor.pl $data $datasetN > $outFolder/$dbName.ds$datasetN.fa
else
	echo $datasetN
	perl $PerlFolder/piRbase_readsExtractor.pl $data $datasetN > $outFolder/$dbName.ds$datasetN.fa
fi

# Dataset summary generator ->  colnames: dataset seq Total_reads
echo -e "dt:$datasetN\tSeq:"`grep -v -c "piR-mm" $outFolder/$dbName.ds$datasetN.fa `"\tTot_Reads:"`grep ">" $outFolder/$dbName.ds$datasetN.fa | awk 'BEGIN{FS="|";SUM=0} {SUM+=$3}END{print SUM}' ` >> $outFolder/Summary_reads_per_ds.txt

done

## "Merging all datasets sequences" ##

cat *.fa > $outFolder/$dbName.all.pre.fa # concatenate all ds files

wc -l $outFolder/$dbName.all.pre.fa # count piRNAs with dupl
grep ">" -c $outFolder/$dbName.all.fa # count piRNA number after remove dupl

# cleaning
rm $outFolder/$dbName.all.pre.* # remains all.fa, wo dup seq
