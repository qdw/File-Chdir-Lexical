package File::Chdir::Lexical; {
    use strict;
    use warnings;

    my $debug = 0;
    sub debug {
        print @_, "\n" if $debug;
    }

    sub new {
        my ($class) = @_;
        return bless \(my $self), $class;
    }

    sub DESTROY {
    }
}

1;

__END__

=head1 NAME

DEPRECATED.  use File::chdir instead.

File::Chdir::Lexical - automatically chdir's back to previous dir
(when exiting lexical scope), so you don't forget.  Saves typing.

=head1 SYNOPSIS

   # DEPRECATED.  use File::chdir instead.

   use File::Chdir::Lexical;
   ...

   # Do stuff in original dir
   ...

   # Do stuff specific to /var      
   {       # start new lexical (sub-)scope
       my $handle = File::Chdir::Lexical->new('/var');
       ...
   }       # end new lexical (sub-)scope

   # Do more stuff in original dir
   ...

   # Also works in a loop:
   for my $dir (@dirs) {
       my $handle = File::Chdir::Lexical->new($dir);
       ...
   }

=head1 DESCRIPTION

This module simplifies the common task of chdir'ing to a directory, opening
files or running commands there, and then chdir'ing back.

Normally, to accomplish that, you'd have to write something like the following:

use Cwd;
my $original_dir = cwd();
chdir $new_dir or die "Couldn't chdir to $new_dir: $!. Failed";
# Do things in $new_dir
...
chdir $original_dir or die "Couldn't chdir back to $original_dir: $!.  Failed";

=head2 EXPORT

None.  Use the OO interface:

my $handle = File::Chdir::Lexical->new();

=head1 SEE ALSO

File::Chdir::Lexical is deprecated.  David Golden's File::chdir is a more
elegant solution for almost all cases.  It uses a global tied variable $CWD:

use File::chdir;
sub do_various_dirs {
    # Do stuff in original dir
    ...

    # Do stuff in /var
    {
        local $CWD = '/var'; # changes dir
        ...
    } # end scope, so we change back to the original dir

    # Do more stuff in original dir
    ...
}

=head1 BUGS

None.  But File::chdir has an easier-to-use interface, so I recommend it
instead.

=head1 AUTHOR

Quinn Weaver <quinn@fairpath.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008, Quinn Weaver.  All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See http://dev.perl.org/licenses/
