package Algorithm::QLearning::NFQ;

=head1 NAME

Algorithm::QLearning::NFQ - Q-Learning with AI::FANN

=head1 DESCRIPTION

L<Algorithm::QLearning::NFQ> It's an implementation of Q-Learning with Neural Network using L<AI::FANN>.

=cut


use Algorithm::QLearning -base;
use List::Util qw(max);
use AI::FANN qw(:all);
use Algorithm::QLearning;
use constant DEBUG => $ENV{DEBUG} || 0;


=head1 ATTRIBUTES

=head2 auto_learn

Defaults to C<1>, enables online learning mode

=cut

has auto_learn => sub {1};

=head2 choose_best_factor

Defaults to C<0.1>, it's the probability to choose a random path on each turn

=cut

has choose_best_factor => sub {0.1};

=head2 max_epochs

Defaults to C<500000>, it's the max epochs to learn the NN

=cut

has max_epochs => sub {500000};

=head2 epochs_between_reports

Defaults to C<1000>,  FANN learning attriibute, see L<AI::FANN>

=cut

has epochs_between_reports => sub {1000};

=head2 desired_error

Defaults to C<0.01>,  FANN learning attriibute, see L<AI::FANN>

=cut

has desired_error => sub {0.01};

=head2 outputs

Defaults to C<1>,  FANN neuron outputs of the function, see L<AI::FANN>

=cut

has outputs => sub {1};

=head2 hidden_layers

Defaults to C<3>,  FANN neuron hidden layers, see L<AI::FANN>

=cut

has hidden_layers => sub {3};

=head2 brain

Optional, define a ANN file where to save the neural network

=head2 inputs

FANN input size, see L<AI::FANN>

=cut

has [qw(brain inputs)];

=head2 nn

returns the AI::FANN instance

=cut

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

=head1 METHODS

=head2 train

Returns the qvalue of the Q-Learning function using the NN.

Takes as input: current status, current action, environment result status, environment reward, [best_possible value for next state, optional]

=cut

sub train {
    my $self = shift;
    warn "[*] training @_" if DEBUG;
    my $qv = $self->qfunc(@_);
    $self->_nn_train( [ @{ $_[0] }, $_[1] ], [$qv] ) if $self->auto_learn;
    $self->nn->save( $self->brain ) if $self->brain;
    return $qv;
}

=head2 _bpv

returns the best possible value using the NN, it's internal

Takes as input: current status, [best_possible value for next state, optional]

=cut

sub _bpv {
    my $self = shift;
    my $s    = shift;
    warn "[*] calculating bpv for @{$s}" if DEBUG;
    my $bpv = shift;
    $bpv // max( map { $self->nn->run( [ @{$s}, $_ ] )->[0] }
            @{ $self->actions } );
}

=head2 __nn_train

trains the NN with the given arguments

Takes as input: train_data_input, train_data_desired_output

=cut

###### xor train example
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

=head1 LICENSE

Copyright (C) mudler.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mudler E<lt>mudler@dark-lab.netE<gt>

=cut

1;
