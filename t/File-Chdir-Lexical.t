#!/usr/bin/env perl

use Test::More tests => 2;
use_ok('File::Chdir::Lexical');

sub get_fixture {
    return File::Chdir::Lexical->new();
}

{
    my $fixture = get_fixture();
    isa_ok($fixture, 'File::Chdir::Lexical');
}
