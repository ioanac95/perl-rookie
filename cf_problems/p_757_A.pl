use v5.20;

use List::Util qw[min max];


my $target = "uaBlbsr";
my %ap;

my $text = <>;
for (my $i = 0; $i < length $text; $i++) {
	my $ind = index($target, substr($text, $i, 1));
	if ($ind != -1) {
		$ap{$ind}++;
	}
}

my $mn = min($ap{0} / 2, $ap{1} / 2);
for (my $i = 2; $i < length $target; $i++) {
	$mn = min($mn, $ap{$i});
}

say $mn;