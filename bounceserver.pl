use strict;
use warnings;
use Net::Server::Mail::SMTP::Prefork;
use Resque;


my $resque = Resque->new(redis => '127.0.0.1:6379');

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

    if ($reason && $to) {
        $resque->push('bounce' => {
            class => 'My::Bounce',
            args  => [ $reason, $sender ],
        });
    }

    return (1, 250, 'message queued');
});
$server->run;

