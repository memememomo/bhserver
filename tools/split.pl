use strict;
use warnings;


my $number = 1;
my @lines;
while (my $line = <ARGV>) {
    if ($line =~ /^From /) {
        if (@lines) {
            my $str  = join('', @lines);
            open my $fh, '>', "data/$number.txt" or die "";
            print $fh $str;
            close $fh;
            @lines = ();
            $number += 1;
        }
    }
    else {
        push @lines, $line;
    }
}
