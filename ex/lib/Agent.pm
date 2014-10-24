package Agent;
use Deeme::Obj -base;
use Carp;
use feature 'say';
use Data::Printer;

sub register {
    my $agent = shift;
    my $env   = shift;
    $env->on(
        update_beliefs => sub {
            $agent->learn(@_);
        }
    );
    $env->on(
        tick => sub {
            $env->emit(
                choise_result => (
                    $agent,
                    $agent->choose( $env->{status}->{$agent} ),
                    $env->{status}->{$agent}
                )
            );
        }
    );
}

sub choose {
    croak 'choose() not implemented by Agent base class';
}

sub learn {
    croak 'learn() not implemented by Agent base class';
}

1;
