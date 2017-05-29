use v5.20;
use Data::Dumper;
use Switch;

sub valid_username {
	my ($username) = @_;
	return length $username >= 1 && $username =~ /^[a-zA-Z][a-zA-Z0-9_]*$/;
}

sub valid_password {
	my ($password) = @_;
	return (length $password >= 6) && ($password =~ /^[a-zA-Z0-9_]+$/)
								   && ($password =~ /[a-z]+/)
								   && ($password =~ /[A-Z]+/)
								   && ($password =~ /[0-9]+/);
}

sub get_user_pass {
	my ($user_pair) = @_;
	my @tokens = split /\[|\]/, $user_pair;
	if (scalar @tokens != 4) {
		die "Corrupted file.";
	}
	return ($tokens[1], $tokens[3]);
}

sub request_credentials {
	print "Username: ";
	my $username = <>;
	chomp $username;

	print "Password: ";
	my $password = <>;
	chomp $password;
	return ($username, $password);
}

sub login_prompt {
	my ($filename) = @_;
	my ($username, $password) = request_credentials();

	open(my $file_handle, '<:encoding(UTF-8)', $filename)
  		or die "Could not open file '$filename' $!\n";

	# Search for username in the file.
	my $found = 0;
	while (my $row = <$file_handle>) {
	  chomp $row;
	  my ($u, $p) = get_user_pass($row);
	  if ($u eq $username and $p eq $password) {
	  	$found = 1;
	  }
	}

	close $file_handle
  		or die "Could not close file handle for file $filename.\n";

	return $found;
}

sub add_user_prompt {
	my ($filename) = @_;
	my ($username, $password) = request_credentials();
	if (not(valid_username($username) and valid_password($password))) {
		print ("Invalid username/password combination.\n");
		return;
	}

	open(my $file_handle, '>>', $filename)
  		or die "Could not open file '$filename' $!\n";

  	say $file_handle "[$username][$password]";

  	close $file_handle
  		or die "Could not close file handle for file $filename.\n";
}

say "Welcome. You might be among the special ones having an account on our platform. \nPlease insert your credentials to find out and gain access to cool features!";

my $filename = 'login.txt';

my $logged_in = 0;
my $exit_req = 0;
while (not $exit_req) {
	if ($logged_in) {
		print ("Type 1 to log out, 2 to add a new user, 0 to exit.\n");
		my $option = <>;
		chomp $option;

		switch ($option) {
			case 1 { print ("You are now logged out.\n"); $logged_in = 0; }
			case 2 { add_user_prompt($filename); }
			case 0 { $exit_req = 1; }
			else { print ("Invalid option.\n"); }
		}
	} else {
		print ("Type 1 to log in, 0 to exit.\n");
		my $option = <>;
		chomp $option;

		switch ($option) {
			case 1 {
				my $found = login_prompt($filename);
				if ($found) {
					print "Logged in.\n";
					$logged_in = 1;
				} else {
					print "Could not log you in. Invalid username or password.\n";
				}
			} case 0 {
				$exit_req = 1;
			} else {
				print ("Invalid option.\n");
			}
		}
	}
	
}
