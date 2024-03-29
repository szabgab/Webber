use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share 'share';

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Webber',
    AUTHOR              => q{Gabor Szabo <cpan@szabgab.com>},
    VERSION_FROM        => 'lib/Webber.pm',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES => ['bin/webber'],
    PREREQ_PM => {
        'Test::More'              => 0,
        'YAML'                    => 0,
        'Dancer'                  => 1.3121,
        'Template'                => 0,
        'YAML'                    => 0,
        'Moo'                     => 0,
        'MooX::Options'           => 0,
        'Path::Iterator::Rule'    => 0,
        'File::ShareDir'          => 0,
        'File::ShareDir::Install' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Webber-*' },
);

package MY;
use File::ShareDir::Install qw(postamble);

