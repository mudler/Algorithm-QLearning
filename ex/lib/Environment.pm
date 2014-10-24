package Environment;
use Deeme -base;
use Carp;
use feature 'say';
use Storable 'dclone';
sub subscribe {
    $_[1]->register( $_[0] );
    $_[0]->{status}->{ $_[1] } = [0,0];
}

sub run {
    $_[0]->on(
        choise_result => sub {
            my $env = shift;
            my $current_status=dclone($env->{status}->{ $_[0] });
            print STDERR "Env: current status @{$current_status}\n";
            my @r = @{$env->process( @_ )};
            $env->{status}->{ $_[0] } = $r[0];
            $env->emit( update_beliefs => ($current_status,$_[1],@r) );
        }
    );
    while (1) { $_[0]->emit("tick") }
}

sub process {
    croak 'process() not implemented by base class';
}

1;
