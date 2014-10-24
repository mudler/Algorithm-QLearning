#!/usr/bin/perl

use lib 'lib';
use lib '../lib';
use Agent::ANNQLearning;
use Environment::ANNQLearningEnv;
my $env = Environment::ANNQLearningEnv->new;
use constant UP    => 0;
use constant DOWN  => 1;
use constant LEFT  => 2;
use constant RIGHT => 3;

$env->subscribe(
    Agent::ANNQLearning->new(
        brain              => "test.ann",
        inputs             => "3",
        hidden_layers      => 5,
        outputs            => 1,
        auto_learn         => 1,
        actions            => [ UP, DOWN, LEFT, RIGHT ],
        choose_best_factor => 0,
        discount_factor    => 0.9,
        learning_rate      => 0.7,

    )
);

$env->run;
