package File::Chdir::Lexical; {
    use strict;
    use warnings;

    sub debug {
        print @_, "\n" if $debug;
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
