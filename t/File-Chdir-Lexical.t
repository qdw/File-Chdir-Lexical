#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;

use_ok('Cwd', 'cwd');

BEGIN {
    use_ok('FindBin');
}
use lib "$FindBin::Bin/../lib";
use_ok('File::Chdir::Lexical');

sub abs_path {
    my ($path) = @_;

    # If it doesn't start with a slash, reckon it relative to this program's
    # path.  (If it does start with a slash, it's already absolute, so we just
    # return an identical string.)
    $path .= $FindBin::Bin . "/$path" if $path !~ m{\A /}smx;

    return $path;
}

sub canonical_path {
    my ($path) = @_;
    
    $path = abs_path $path;

    # Change foo/bar/../batz to foo/batz, which is equivalent.
    $path =~ s{ / ([^/])+? / [.][.] }{}gsmx;

    return $path;
}

SKIP: {
    my $handle;
    skip(q{because I need to install Test::Exception once I'm off this airplane}, 1);
    use_ok('Test::Exception');
    lives_ok {
        $handle = File::Chdir::Lexical->new('../lib'); # since we have perms
    }
}

{
    # Test chdir'ing to ../lib, since we know we have execute permissions there.

    my $original_dir = cwd();
    
    { # Start a new lexical scope for the target directory.
        my $target_dir = canonical_path($FindBin::Bin . '/../lib');
        ok(
            $target_dir ne $original_dir,
            'our original directory is not the same as the target directory'
        );

        my $handle = File::Chdir::Lexical->new($target_dir);
        isa_ok(
            $handle,
            'File::Chdir::Lexical',
            q{new's return value}
        );

        ok(
            cwd() eq $target_dir,
            q{after constructor call, we're in the target directory}
        );
    } # The new lexical scope ends; the garbage collector calls $handle->DESTROY

    is(
        cwd(),
        $original_dir,
        q{after popping out of the new scope, we're back in the original dir'}
    );
}
