package Bhserver::Deliver;

use strict;
use warnings;
use utf8;
use File::Basename;

sub sendmail {
    my ($self, $reason, $to) = @_;

    my $from = 'bouncer@example.com';

    my $smtp = Net::SMTP->new(
        Host  => '',
        Port  => '25',
        Hello => 'hello',
    );

    my $dir = dirname(__FILE__) . '/../../data';

    my %map =  (
        hostunknown => "1.txt",
        mailererror => "35.txt",
        userunknown => "13.txt",
        mesgtoobig  => "12.txt",
        mailboxfull => "33.txt",
        filtered    => "36.txt",
        securityerr => "24.txt",
        systemerror => "34.txt",
    );

    my $file = $map{$reason};

    if ($file) {
        open my $fh, "$dir/$file" or die "";
        my $mailtext = join('', <$fh>);
        close $fh;

        $smtp->mail($from);
        if ($smtp->to($to)) {
            $smtp->data();
            $smtp->datasend($mailtext);
            $smtp->dataend();
        }
    }
}



1;
