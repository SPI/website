#!/usr/bin/perl

use warnings;
use strict;

sub error($$) {
	my ($context, $message) = @_;
	print STDERR "$context: $message\n";
}

my $context = "outside";
my $in_table = 0;
my $seen_table = 0;
while (<>) {
	if (/^#+ (.+)/) {
		my $title = $1;
		$context = $1;
		$seen_table = 0;
		if (/\d+ election results/) {
			print "# $title\n";
		} else {
			print "## $title\n";
		}
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
	} elsif ($context eq "Votes") {
		chomp;
		if ($seen_table) {
			# Show everything after the first table.  This is a
			# workaround for 2018-board-election/results.mdwn
			# which has a second table which can't be converted
			# right now.
			print "$_\n";
		} elsif (m#^(<table>|<thead>|\s*<tr><th>Index</th>\s*<th>Vote</th></tr>|</thead>|<tbody>|\s*<tr><th>Index</th><th>Hash identifier</th><th>Vote cast</th></tr>)$#) {
			# Skip headers
			$in_table = 1;
		} elsif (m#^(The votes cast|unique hash|properly. After|hash is the only)#) {
			# some text
			print "$_\n";
		} elsif (m#^\s*<tr><td>([\d\w]+)</td><td>(\w*)</td></tr>$#) {
			if ($2) {
				print "\t$1 $2\n";
			} else {
				print "\t$1\n";
			}
		} elsif (m#^\s*<tr><td>\d+</td><td class="monowidth">([\d\w]+)</td><td>(\w*)</td></tr>$#) {
			if ($2) {
				print "\t$1 $2\n";
			} else {
				print "\t$1\n";
			}
		} elsif (m#^$#) {
			# Skip empty line in table
			print "\n" if !$in_table;
		} elsif (m#^</tbody>$#) {
			# Skip footer
			$in_table = 0;
		} elsif (m#^</table>$#) {
			# Skip footer
			$in_table = 0;
			$seen_table = 1;
		} elsif (!$in_table && /^\t[\d\w]+/) {
			# Already Markdown
			print "$_\n";
			$seen_table = 1;
		} elsif (/\.png/) {
			print "$_\n";
		} else {
			error $context, "Unknown line: $_";
		}
	} elsif ($context eq "Results") {
		chomp;
		if (m#^(<table>|<tbody>)$#) {
			# Skip headers
			$in_table = 1;
		} elsif (m#^(These are the results|There were)#) {
			print "$_\n";
		} elsif (m#<tr><td>(<b>)?(.+?)(</b>)?</td></tr>#) {
			my $name = $2;
			$name = "**$name**" if defined $1; # bold
			print "1. $name\n";
		} elsif (m#^$#) {
			# Skip empty line in table
			print "\n" if !$in_table;
		} elsif (m#^(</tbody>|</table>)$#) {
			# Skip footer
			$in_table = 0;
			$context = "" if m#^</table>$#;
		} elsif (!$in_table && /^(\s*\d+\.|\*) [*\w]/) {
			# Already Markdown
			print "$_\n";
		} elsif (/results.*png/) {
			print "$_\n";
		} else {
			error $context, "Unknown line: $_";
		}
	} else {
		print "$_";
	}
}

