package Bhserver::Server;

use strict;
use warnings;
use utf8;
use base 'Bhserver::Base';
use Bhserver::Resque;
use Net::Server::Mail::SMTP::Prefork;


sub run {
    my $self = shift;

    my $resque = Bhserver::Resque->new;

    my $server = Net::Server::Mail::SMTP::Prefork->new(
        %{$self->config->server}
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

    warn "run server pid: $$\n";
    $server->run;
}


1;
