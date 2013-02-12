use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    dist_name => 'Lelf-Email',
    script_files => 'script/count-mails',
    dist_abstract => 'email counting',
    license             => 'bsd',
    dist_author         => q{Anton Nikishaev <me@lelf.tk>},
    dist_version_from => 'script/count-mails',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
	'IPC::Run3' => 0,
	'Test::Perl::Critic' => 0,
	'String::Random' => 0,
    },
    requires => {
	'Modern::Perl' => 0,
	'Regexp::Grammars' => 0,
    },
    add_to_cleanup     => [ 'Lelf-Email-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
