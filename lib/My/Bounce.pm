package My::Bounce;

use strict;
use warnings;
use Net::SMTP;
use File::Basename;


sub perform {
    my $job = shift;
    my $args = $job->args;

    my $from = 'bouncer@example.com';

    my $smtp = Net::SMTP->new(
        Host  => '',
        Port  => '',
        Hello => '',
    );

    my $reason = $args->[0];
    my $to     = $args->[1];

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
