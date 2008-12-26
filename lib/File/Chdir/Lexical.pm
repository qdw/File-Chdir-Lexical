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
