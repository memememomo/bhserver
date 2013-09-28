+{
    'Net::SMTP' => {
        Host => 'localhost',
        Port => 25,
        Hello => 'hello',
    },
    'Net::Server::Mail::SMTP::Prefork' => {
        host => 'localhost',
        port => 25,
        max_workers => 2,
    },
}
