#!/usr/bin/perl

use Modern::Perl;
use Test::More qw{no_plan};
use IPC::Run3;

my %emails;

open my $data, 't/data/emails-validated';
while (<$data>) {
    /^\s+ \("(?<email>.*)" (?=,) ,\s (?<valid>(True)?)/x;
    $emails{$+{email}} = $+{valid};
}


while (my ($email, $valid) = each %emails) {
    my $in = [$email];
    my $out;
    run3 ['scripts/count-mails'], $in, \$out;

    my $v = $out !~ /INVALID/;

    ok(! $valid == $out =~ /INVALID/, "email $email");
}

