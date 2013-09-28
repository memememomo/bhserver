package Bhserver::Config;

use strict;
use warnings;
use File::Basename;



sub new {
    my ($class) = @_;
    my $path = dirname(__FILE__) . '/../../config.pl';
    bless {
        config => do $path
    }, $class;
}

sub resque {
    my $self = shift;
    $self->{config}->{Resque};
}

sub smtp {
    my $self = shift;
    $self->{config}->{'Net::SMTP'};
}

sub server {
    my $self = shift;
    $self->{config}->{'Net::Server::Mail::SMTP::Prefork'};
}

1;
