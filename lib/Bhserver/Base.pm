package Bhserver::Base;

use strict;
use warnings;
use utf8;
use Bhserver::Config;


sub new {
    my $class = shift;
    bless {
        config => Bhserver::Config->new,
        @_
    }, $class;
}

sub config { shift->{config} }

1;
