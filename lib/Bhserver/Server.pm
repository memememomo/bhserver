package Bhserver::Server;

use strict;
use warnings;
use Bhserver::Resque;
use Net::Server::Mail::SMTP::Prefork;


sub new {
    my ($class) = @_;
    return {}, $class;
}

sub run {
    my $self = shift;

    my $resque = Bhserver::Resque->new;

    my $server = Net::Server::Mail::SMTP::Prefork->new(
        host => 'localhost',
        port => 25,
        max_workers => 2,
    );

    $server->set_callback('RCPT' => sub { return (1) });
    $server->set_callback('DATA' => sub {
        my ($session, $data) = @_;

        my $sender = $session->get_sender();
        my @recipients = $session->get_recipients();

        my $to = $recipients[0];
        my ($reason, $host) = split(/\@/, $to);

        $resque->push($reason, $sender);

        return (1, 250, 'message queued');
    });
    $server->run;
}


1;
