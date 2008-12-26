#!/usr/bin/env perl

use Test::More tests => 3;

use lib '../lib';
use_ok('File::Chdir::Lexical');

{
    my $fixture = get_fixture();
    isa_ok($fixture, 'File::Chdir::Lexical', q{constructor's return value});
}

sub get_fixture() {
    return File::Chdir::Lexical->new();
}

1;
