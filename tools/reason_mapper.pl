use strict;
use warnings;
use Encode;
use JSON::XS;

my $parser = JSON::XS->new;
my $bin = '/usr/local/bouncehammer/bin/mailboxparser';

my %reasons;
opendir my $dh, 'data';
while (my $file = readdir($dh)) {
    next if $file =~ /^\./;
    my $path = "splited/$file";
    my $json = `$bin $path`;
    $json =~ s/^\-//;
    my $hash;
    $hash = JSON::XS::decode_json($json);
    # warn '------------------------------';
    # warn $hash->{reason};
    # warn $hash->{description}->{smtpagent};
    $reasons{$hash->{reason}} ||= $file;
}
closedir $dh;

for my $reason (keys %reasons) {
    print "$reason => $reasons{$reason}\n";
}

# { "bounced": 1228701897, "addresser": "user@example.co.jp", "recipient": "this-user-does-not-exist-on-the-server@ezweb.ne.jp", "senderdomain": "example.co.jp", "destination": "ezweb.ne.jp", "reason": "userunknown", "hostgroup": "cellphone", "provider": "aubykddi", "frequency": 1, "description": { "deliverystatus": "5.0.911", "diagnosticcode": "The user(s) account is disabled. user unknown", "listid": "", "smtpagent": "JP::aubyKDDI", "timezoneoffset": "+0900" }, "token": "099d8a5ebe8c56a0044e0685eb85c57a" }
