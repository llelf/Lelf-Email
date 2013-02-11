use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Lelf::Email',
    license             => 'Artistic_2_0',
    dist_author         => q{Anton Nikishaev <me@lelf.tk>},
    dist_version_from   => 'lib/Lelf/Email.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
	'Modern::Perl' => 0,
	'Email::Address' => 0,
    },
    add_to_cleanup     => [ 'Lelf-Email-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
