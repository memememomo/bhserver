package Bhserver::Pipe;

use strict;
use warnings;
use utf8;
use Email::MIME::MobileJP::Parser;
use Bhserver::Resque;


sub run {
    my $self = shift;

    my $message = '';
    while (my $buf = <STDIN>) {
        $message .= $buf;
    }

    my $mail = Email::MIME::MobileJP::Parser->new($message);
    my $sender = $mail->mail->header('Return-Path') || $mail->from();
    my ($to) = $mail->to();

    my $reason = $to->user;

    if ($reason && $sender) {
        Bhserver::Resque->new->push($reason, $sender);
    }
}


1;
