# NAME

Algorithm::QLearning - Reinforcement Learning done in Pure Perl

# DESCRIPTION

[Algorithm::QLearning](https://metacpan.org/pod/Algorithm::QLearning) is a base class for implementations of Q-Learning based algorithms written in Pure Perl, have a look at [Algorithm::QLearning::NFQ](https://metacpan.org/pod/Algorithm::QLearning::NFQ) for a Neural Network implementation.

# ATTRIBUTES

## discount\_factor

Defaults to `0.5`, it's the discount factor of the Q-Learning function.

## learning\_rate

Defaults to `1`, it's the learning rate of the Q-Learning function.

# METHODS

## qfunc

Returns the qvalue of the Q-Learning function.

Takes as input: current status, current action, environment result status, environment reward, \[best\_possible value for next state, optional\]

## \_bpv

Represent the best possible value, it's internal

# LICENSE

Copyright (C) mudler.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

mudler <mudler@dark-lab.net>
