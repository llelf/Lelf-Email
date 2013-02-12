#!/usr/bin/perl

# You wanted 'automatic' tests

use Modern::Perl;
use Test::More qw{no_plan};
use IPC::Run3;
use String::Random;


# Output is sorted by count
sub prop_sorted {
    my (undef, undef, $out) = @_;

    $out->[$_-1][1] >= $out->[$_][1] or $out->[$_][0] eq 'INVALID'
	or return 0
	for (1 .. $#$out);

    return 1;
}

# Sum of counts in output = input addrs count
sub prop_count {
    my ($in, $valid, $out) = @_;

    my $out_count = 0;
    $out_count += $_->[1] for @$out;

    return @$in == $out_count;
}

# Valid @google.com addrs count in input is the same in output
sub prop_count_google {
    my ($in, $valid, $out) = @_;

    my $in_count = grep { /\@google.com$/ and $valid->{$_} } @$in;
    my ($goo) = grep { $_->[0] eq 'google.com' } @$out;
    my $out_count = $goo->[1] // 0;

    return $in_count == $out_count;
}

my %props = (prop_sorted => \&prop_sorted,
	     prop_count => \&prop_count,
	     prop_count_google => \&prop_count_google);



# Don't read below

my $rand = String::Random->new;
$rand->{X} = [ 'a'..'z', '+.' ];

my @domains = qw{localhost foo.bar.baz ya.ru google.com};


sub arbitrary_addr {
    my $loc = $rand->randpattern('X' x (1 + rand 20));
    my $dom = $domains[rand @domains];

    my $email = join '@', ($loc, $dom);

    if (int rand 2) {
	my $i = rand length $email;
	my @r = split '', '@.!';
	substr($email, $i, 1) = $r[rand @r];
    }

    return $email;
}


foreach my $test (1..10) {
    my %emails = ();

    for (0 .. rand 50) {
	my $email = arbitrary_addr;

	# Now assume address parsing works right and script gives
	# right result for one address
	run3 ['script/count-mails'], \$email, \my $out;
	my $valid = $out !~ /INVALID/;
	$emails{$email} = $valid;
    }

    my $txt_in = join "\n", keys %emails;
    run3 ['script/count-mails'], \$txt_in, \my $txt_out;

    my @out = map { [ split /\t/, $_ ] } split "\n", $txt_out;
    
    for my $p (keys %props) {
	ok($props{$p}->([keys %emails], \%emails, \@out), "test $test: $p");
    }
}

