#!/usr/bin/perl -l
use warnings;
use strict;

#This program will extract detected data in each dataset (THAT DONT HAVE SEQUENCES (no reads)!!) for piRbase data
# by Odei :)
# 12.1.21

# Input
my $inputfile = $ARGV[0];
my $dataset = $ARGV[1];

# usage
# perl piRbase_seq_Extractor.pl piR_mmu.txt <5 or 134>

open(INFILE, "<$inputfile") or die "Couln't open $inputfile";

# text analysis
while (my $data = <INFILE>) {

foreach (split(/\n/,$data)) {

my $regex = qr/(piR-mmu-[0-9*]+).+\t([ATGCN]+)\t([0-9]*)\t*.*[ \t]$dataset[ \t].*/mp;
# match desired dataset between spacer or tabs (to avoid four reads matches ds:Reads)

if ( $_ =~ /$regex/g ) {

# 1 is piRNA name
# 2 is Seq
# 3 is Length

# simple print
#	print "$1 $2 $3";

# print at fasta format
	print ">$1|$3\n$2";

}


}
}
