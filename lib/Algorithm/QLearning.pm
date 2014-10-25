package Algorithm::QLearning;

=head1 NAME

Algorithm::QLearning - Reinforcement Learning done in Pure Perl

=head1 DESCRIPTION

L<Algorithm::QLearning> is a base class for implementations of Q-Learning based algorithms written in Pure Perl, have a look at L<Algorithm::QLearning::NFQ> for a Neural Network implementation.

=cut

use 5.008001;
use strict;
use warnings;

use Algorithm::QLearning::Base -base;
use Carp;
use constant DEBUG => $ENV{DEBUG} || 0;

our $VERSION = "0.01";

=head1 ATTRIBUTES

=head2 discount_factor

Defaults to C<0.5>, it's the discount factor of the Q-Learning function.

=cut

has discount_factor => sub {0.5};

=head2 learning_rate

Defaults to C<1>, it's the learning rate of the Q-Learning function.

=cut

has learning_rate => sub {1};

=head2 epsilon

Defaults to C<0.1>, it's the probability to choose a random path

=cut

has epsilon => sub {0.1};

=head2 actions

List of actions of the system (needed if your environment doesn't send the best possible volue for the agent, this enables the automatic search of the best possible value for the next state)

    [1,2,3,4]

=cut

has [qw(actions)];

=head1 METHODS

=head2 qfunc

Returns the qvalue of the Q-Learning function.

Takes as input: current status, current action, environment result status, environment reward, [best_possible value for next state, optional]

=cut

#Vest = r_imm + gamma*[ max(a{t+1}) Qn(s{t+1}, a{t+1})]
sub qfunc {
    return $_[0]->learning_rate
        * ( $_[4] + ( $_[0]->discount_factor * $_[0]->_bpv( $_[3] ) ) );
}

=head2 egreedy

Return the new picked action, based on the epsilon specified, and the given actions

=cut

sub egreedy {
    my $self   = shift;
    my $status = shift;
    if ( rand(1) < $self->epsilon ) {
        return $self->actions->[ int( rand( scalar( @{ $self->actions } ) ) )
        ];
    }
    else {
 #orders by value the hash given by the actions reward for the current status.
        my %action_rewards
            = map { $_ => $self->nn->run( [ @{$status}, $_ ] )->[0] }
            @{ $self->actions };
        if (DEBUG) {
            foreach my $k ( keys %action_rewards ) {
                warn "$k: " . $action_rewards{$k} . "\n";
            }
        }
        return ~~ (
            sort { $action_rewards{$a} <=> $action_rewards{$b} }
                keys %action_rewards
        )[-1];
    }
}

=head2 _bpv

Represent the best possible value, it's internal
=cut

sub _bpv {
    croak '_bpv() not directly implemented by Algorithm::QLearning';
}

=head1 LICENSE

Copyright (C) mudler.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mudler E<lt>mudler@dark-lab.netE<gt>

=cut

1;
__END__
