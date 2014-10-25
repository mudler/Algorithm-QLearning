requires 'AI::FANN';
requires 'Data::Printer';
requires 'Deeme';
requires 'Deeme::Obj';
requires 'List::Util';
requires 'feature';
requires 'perl', '5.008001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
