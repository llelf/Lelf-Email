#!/usr/bin/perl

use Modern::Perl;
use Test::More qw{no_plan};
use IPC::Run3;

foreach my $file_in (<t/data/data*.in>) {
    (my $file_out = $file_in) =~ s{\.in}{\.out};

    run3 ['scripts/count-mails'], $file_in, \my $out;

    open(my $o, $file_out);

    local $/ = undef;
    my $exp_out = <$o>;

    ok($out eq $exp_out, "test $file_in");
}

