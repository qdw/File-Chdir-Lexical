package File::Chdir::Lexical; {
    use strict;
    use warnings;

    my $debug = 0;

    sub debug {
        print @_ if $debug;
    }

    sub new {
        my ($class) = @_;
        debug 'in sub new';
        return bless {}, $class;
    }

    sub DESTROY {
        debug 'in sub DESTROY';
    }
}

1;
