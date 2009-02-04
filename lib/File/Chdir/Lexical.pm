package File::Chdir::Lexical; {
    use strict;
    use warnings;

    use Cwd;

    my $debug = 0;
    sub debug {
        print @_, "\n" if $debug;
    }

    sub new {
        my ($class, $target_dir) = @_;
        my $original_dir = cwd();
        
        chdir $target_dir
            or die "Couldn't chdir to target directory '$target_dir': $!";

        my $self = {
            target_dir    =>  $target_dir,
            original_dir  =>  $original_dir,
        };
        
        return bless $self, $class;
    }

    sub DESTROY {
        my ($self) = @_;
        my $original_dir = $self->{original_dir};
        my $target_dir   = $self->{target_dir};
        
        if ($self->{original_dir} eq $self->{target_dir}) {
            return;
        }
        else {
            my $od = $self->{original_dir};
            chdir $od
                or die "Couldn't change back to original directory '$od': $!";
        return;
        }
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

=head1 DIAGNOSTICS

This module dies with an informative string error string if it can't chdir
to or from your directory.  That's because your code can't safely continue
without chdiring to the right directory.  The safest thing is to bail out.
For more on this philosophy, see Damian Conway's Perl Best Practices,
p. 274 (first edition).

If you want to catch these exceptions at runtime and deal with them
safely, you need to write code like this:

{
    my $handle;
    eval { $handle = File::Chdir::Lexical->new('/var'); };
    if ($@) {
        # handle error...
    }
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

=head1 EXPORT

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

=head1 BUGS AND LIMITATIONS

File::chdir has an easier-to-use interface, so I recommend using it instead.

File::Chdir::Lexical uses conventional Perl blessed-hashref objects,
so a user really bent on self-sabotage could reach in and mutate
$handle->{target_dir} or $handle->{original_dir}.  But who would want to
do that?  Besides, the alternative was to force a dependency on
Object::InsideOut, which is far too heavyweight for a quickie module like this.

=head1 AUTHOR

Quinn Weaver <quinn@fairpath.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008, Quinn Weaver.  All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl 5 itself.  See http://dev.perl.org/licenses/

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
