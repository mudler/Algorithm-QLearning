package Environment::ANNQLearningEnv;
use Deeme::Obj "Environment";
use feature 'say';
use Data::Printer;

use constant UP    => 0;
use constant DOWN  => 1;
use constant LEFT  => 2;
use constant RIGHT => 3;
has rewards        => sub {
    [   [ 0, 0, 0, 0,   0, 0 ],
        [ 0, 1, 2, 3,   1, 1 ],
        [ 0, 1, 1, 4,   1, 1 ],
        [ 1, 1, 1, 999, 1, 0 ],
        [ 1, 1, 1, 1,   1, 1 ],
        [ 0, 0, 0, 0,   0, 0 ],
    ];
};

sub process {
    my $env    = shift;
    my $agent  = shift;
    my $action = shift;
    my $status = shift;

    #say "Action : $action , status: " . p($status);

    #sleep 1;
    # Change status of the agent
    $status->[1] += 1 if ( $action eq UP and $status->[1] <= 4 );
    $status->[1] -= 1 if ( $action eq DOWN and $status->[1] >= 1 );
    $status->[0] -= 1 if ( $action eq LEFT and $status->[0] >= 1 );
    $status->[0] += 1 if ( $action eq RIGHT and $status->[0] <= 4 );

    # p( $env->rewards );
    print STDERR "BAD BOYYYYY\n"
        if !exists $env->rewards->[ $status->[1] ]->[ $status->[0] ];

    #returns status and fixed reward
    return [ $status,
        exists $env->rewards->[ $status->[1] ]->[ $status->[0] ]
        ? $env->rewards->[ $status->[1] ]->[ $status->[0] ]
        : -200 ];
}
1;
