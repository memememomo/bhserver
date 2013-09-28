package Bhserver::Resque;

use strict;
use warnings;
use utf8;
use base 'Bhserver::Base';
use Resque;


sub resque {
    my $self = shift;
    Resque->new(redis => '127.0.0.1:6379');
}

sub push {
    my ($self, $reason, $sender) = @_;

    if ($reason && $sender) {
        $self->resque->push('bounce' => {
            class => 'Bhserver::Worker::Bounce',
            args  => [ $reason, $sender ],
        });
    }
}

sub worker {
    my $self = shift;

    warn "### start worker";
    my $worker = $self->resque->worker;
    $worker->add_queue('bounce');
    $worker->work;
}

1;
