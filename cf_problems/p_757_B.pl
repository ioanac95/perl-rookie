use v5.20;

use Data::Dumper;
use List::Util qw[min max];
use Math::Complex;

use constant DN => 100005;

sub Sieve {
	my $th = sqrt(DN);
	my @primes = (2);
	my %viz;
	$viz{2} = 1;

	for (my $i = 3; $i < $th; $i += 2) {
		if ($viz{$i} == 0) {
			push(@primes, $i);
			for (my $j = 2; $i * $j < $th; $j++) {
				$viz{$i * $j} = 1;
			}
		}
	}
	return @primes;
}

sub Factor {
	my ($primes_ref, $np_ref, $n) = @_;
	my @primes = @$primes_ref;
	my %np = %$np_ref;

	my $mx = 0;
	for (my $i = 0; $i < scalar @primes && $primes[$i] <= $n; $i++) {
		if ($n % $primes[$i] == 0) {
			$np{$primes[$i]} ++;
			$mx = max($mx, $np{$primes[$i]});
			while ($n % $primes[$i] == 0) {
				$n /= $primes[$i];
			}
		}
	}

	return ($mx, \%np);
}

my @primes = Sieve();

my $n = <>;
chomp $n;

my $result = 0;
my %np;

my $s = <>;
chomp $s;

my @strengths = split(/ /, $s);
for (my $i = 0; $i < $n; $i++) {
	my $strength = $strengths[$i];
	my ($crt_value, $np_ref) = Factor(\@primes, \%np, $strength);
	%np = %$np_ref;

	$result = max($result, $crt_value);
}

say $result;