#!/usr/bin/perl

use warnings;
use strict;

sub error($$) {
	my ($context, $message) = @_;
	print STDERR "$context: $message\n";
}

my $context = "outside";
my $in_table = 0;
while (<>) {
	if (/^#+ (.*)/) {
		$context = $1;
		print;
	} elsif ($context eq "Voters") {
		chomp;
		if (m#^(<table>|<thead>|\s*<tr><th>Index</th>\s*<th>Name</th></tr>|</thead>|<tbody>)$#) {
			# Skip headers
			$in_table = 1;
		} elsif (m#^\s*<tr><td>\d+</td><td>([^<]+)</td></tr>$#) {
			print "1. $1\n";
		} elsif (m#^$#) {
			# Skip empty line in table
			print "\n" if !$in_table;
		} elsif (m#^(</tbody>|</table>)$#) {
			# Skip footer
			$in_table = 0;
		} elsif (!$in_table && /^\s*\d+\. \w+/) {
			# Already Markdown
			print "$_\n";
		} else {
			error $context, "Unknown line: $_";
		}
	} else {
		print "$_";
	}
}

