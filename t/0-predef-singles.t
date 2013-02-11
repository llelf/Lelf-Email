#!/usr/bin/perl

use Modern::Perl;
use Test::Simple;
use IPC::Run3;

my %emails;

open my $data, 't/data/emails-validated';
while (<$data>) {
    /^\s+ \("(?<email>.*)" (?=,) ,\s (?<valid>(True)?)/x;
    $emails{$+{email}} = $+{valid};
}


while (my ($email, $valid) = each %emails) {
    #say $email;

    my $in = [$email];
    my $out;
    run3 ['scripts/count-mails'], $in, \$out;

    my $v = $out !~ /INVALID/;

    if ($valid xor $v) {
	say "$email fuck ", "[$valid]", "[$v]", ($valid xor $v) and die '';
    }
}


