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
