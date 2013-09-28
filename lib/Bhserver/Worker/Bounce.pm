package Bhserver::Worker::Bounce;

use strict;
use warnings;
use Net::SMTP;
use File::Basename;
use Bhserver::Deliver;


sub perform {
    my $job = shift;
    my $args = $job->args;
    Bhserver::Deliver->new->sendmail(@$args);
}

1;
