#!/usr/bin/perl -l
use warnings;
use strict;

#This program will extract detected data in each dataset for piRbase data
# by Odei :)
# 20.11.20

# Input
my $inputfile = $ARGV[0];
my $dataset = $ARGV[1];

# usage
# perl piRbase_readsExtractor.pl piR_mmu.txt <datasetNumber>

open(INFILE, "<$inputfile") or die "Couln't open $inputfile";

# text analysis
while (my $data = <INFILE>) {

foreach (split(/\n/,$data)) {

my $regex = qr/(piR-mmu-[0-9*]+).+\t([ATGCN]+)\t([0-9]*)\t*.*\D$dataset:(\d+).*/mp;


if ( $_ =~ /$regex/g ) {

# 1 is piRNA
# 2 is Seq
# 3 is Length
# 4 is Reads in that dataset

# simple print
#	print "$1 $2 $3";

# print at fasta format )not checked
	print ">$1|$3|$4\n$2";

}


}
}
