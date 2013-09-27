use strict;
use warnings;
use Bhserver::Resque;
use Resque;

Bhserver::Resque->new->worker;

