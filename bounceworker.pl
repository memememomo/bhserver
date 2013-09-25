use strict;
use warnings;

use Resque;


my $worker = Resque->new(redis => '127.0.0.1:6379')->worker;
$worker->add_queue('bounce');
warn "### start worker";
$worker->work;
warn "### stop worker";

