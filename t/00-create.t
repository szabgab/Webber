use strict;
use warnings;

use Test::More;
#use File::Compare qw(compare);
use File::Compare qw(compare_text);
use File::Copy    qw(copy);

my $update = shift;  # run with a command line flag of 1 to update the expected files

my @files = qw(
    bin/app.pl
    config.yml
    environments/development.yml
    environments/production.yml
    lib/Project/Name.pm
    Makefile.PL
    MANIFEST.SKIP
    public/404.html
    public/500.html
    public/css/error.css
    public/css/style.css
    public/dispatch.cgi
    public/dispatch.fcgi
    public/favicon.ico
    public/images/perldancer-bg.jpg
    public/images/perldancer.jpg
    public/javascripts/jquery-1.11.0.min.js
    t/001_base.t
    t/002_index_route.t
    views/index.tt
    views/layouts/main.tt

    public/css/bootstrap-theme.min.css
    public/css/bootstrap.min.css
    public/javascripts/bootstrap.min.js
);


plan tests => 1 + 2*@files;

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

#diag $dir;

use Webber;
diag "Testing Webber version $Webber::VERSION";
#system "$^X -Ilib bin/webber --name Project::Name --path $dir";
local @ARGV = ('--name', 'Project::Name', '--path', $dir);
Webber->new_with_options->run;

ok(1);

foreach my $file (@files) {
	my $expected = "t/expect1/Project-Name/$file";
	my $received = "$dir/Project-Name/$file";
	if ($update) {
		copy $received, $expected;
	}

	#ok(compare($expected, $received) == 0, $file);
	ok -e $received, "$received exists";
	my @problems;
	ok(compare_text($expected, $received, sub {
		if ($_[0] eq $_[1]) {
			return 0;
		} else {
			push @problems, "fail\nExpected: $_[0]\nReceived: $_[1]";
			return 1;
		}
	}) == 0, $file) or diag @problems;
}
