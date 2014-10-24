package Algorithm::QLearning::NFQ;
use feature 'say';
use constant DEBUG => $ENV{DEBUG} || 0;

use Algorithm::QLearning -base;
use List::Util qw(max);
use AI::FANN qw(:all);

has [qw(brain inputs actions)];
has auto_learn             => sub {1};
has choose_best_factor     => sub {0.1};
has max_epochs             => sub {500000};
has epochs_between_reports => sub {1000};
has desired_error          => sub {0.01};
has outputs                => sub {1};
has hidden_layers          => sub {3};

has nn => sub {
    local $b
        = ( $_[0]->brain and -e $_[0]->brain )
        ? AI::FANN->new_from_file( $_[0]->brain )
        : AI::FANN->new_standard(
        $_[0]->inputs,
        $_[0]->hidden_layers // 10,
        $_[0]->outputs // 1
        );
    $b->hidden_activation_function(FANN_SIGMOID_SYMMETRIC);
    $b->output_activation_function(FANN_SIGMOID_SYMMETRIC);
    return $b;
};

sub _bpv {
    my $self = shift;
    my $s    = shift;
    warn "[*] calculating bpv for @{$s}" if DEBUG;
    my $bpv = shift;
    $bpv // max( map { $self->nn->run( [ @{$s}, $_ ] )->[0] }
            @{ $self->actions } );
}

sub train {
    my $self = shift;
    warn "[*] training @_" if DEBUG;
    my $qv = $self->qfunc(@_);
    $self->_nn_train( [ @{ $_[0] }, $_[1] ], [$qv] ) if $self->auto_learn;
    $self->nn->save( $self->brain ) if $self->brain;
    return $qv;
}

#########################################
# AI::FANN::TrainData->new(
#                                         [-1, -1], [-1],
#                                         [-1, 1], [1],
#                                         [1, -1], [1],
#                                         [1, 1], [-1] );

sub _nn_train($) {
    {
        my $data = AI::FANN::TrainData->new( $_[1], $_[2] );
        $data->shuffle;
        $_[0]->nn->train_on_data(
            $data, $_[0]->max_epochs,
            $_[0]->epochs_between_reports,
            $_[0]->desired_error
        );

    }
}

1;
