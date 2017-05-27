use v5.20;
use Data::Dumper;

my $user_input = <>;
my ($n, $k) = split(/ /, $user_input);

my @divisors;
for (my $d = 1; $d * $d <= $n; $d = $d + 1) {
	if ($n % $d == 0) {
		push(@divisors, $d);
		push(@divisors, $n / $d);
	}
}

@divisors = sort {$a <=> $b} @divisors;

if (scalar @divisors < $k) {
	print -1;
} else {
	print $divisors[$k-1];
}
