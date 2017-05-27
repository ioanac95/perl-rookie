use v5.20;

my $input = <>;
my ($usb_comp, $ps2_comp, $both_comp) = split(/ /, $input);

my $m = <>;
my @usb, my @ps2;
for (my $i = 0; $i < $m; $i = $i + 1) {
	$input = <>;
	chomp $input;
	my ($number, $type) = split(/ /, $input);

	if ($type eq "USB") {
		push(@usb, $number);
	} else {
		push(@ps2, $number);
	}
}

my $price = 0;
my $matched = 0;
# Match as many only-usb computers to usb mouses.
@usb = sort {$a <=> $b} @usb;
my $i = 0;
while ($i < scalar @usb and $usb_comp > 0) {
	$price = $price + $usb[$i];
	$i++;
	$matched++;
	$usb_comp--;
}

# Match as many only-ps2 computers to usb mouses.
@ps2 = sort {$a <=> $b} @ps2;
my $j = 0;
while ($j < scalar @ps2 and $ps2_comp > 0) {
	$price = $price + $ps2[$j];
	$j++;
	$matched++;
	$ps2_comp--;
}

# Match the computers having both ports to cheapest mouses.
while (($j < scalar @ps2 or $i < scalar @usb) and $both_comp > 0) {
	if ($i >= scalar @usb or ($j < scalar @ps2 and $ps2[$j] < $usb[$i])) {
		$price = $price + $ps2[$j];
		$j++;
	} else {
		$price = $price + $usb[$i];
		$i++;
	}
	$matched++;
	$both_comp--;
}

print "$matched $price"
