package Algorithm::QLearning;


=encoding utf-8

=head1 NAME

Algorithm::QLearning - It's new $module

=head1 SYNOPSIS

    use Algorithm::QLearning;

=head1 DESCRIPTION

Algorithm::QLearning is ...

=head1 LICENSE

Copyright (C) mudler.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mudler E<lt>mudler@dark-lab.netE<gt>

=cut


use 5.008001;
use strict;
use warnings;
use Algorithm::QLearning::Base -base;
use Carp;


our $VERSION = "0.01";


has discount_factor    => sub {0.5};
has learning_rate      => sub {1};

#Vest = r_imm + gamma*[ max(a{t+1}) Qn(s{t+1}, a{t+1})]
#takes, current status, current action, environment result status, env reward, [best_possible value for next state]
=head2 qfunc

Input:

=cut
sub qfunc {
    return $_[0]->learning_rate
        * ( $_[4] + ( $_[0]->discount_factor * $_[0]->_bpv( $_[3] ) ) );
}

sub _bpv {
    croak '_bpv() not directly implemented by Algorithm::QLearning';
}


1;
__END__
