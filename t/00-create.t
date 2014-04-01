use strict;
use warnings;

use Test::More;
#use File::Compare qw(compare);
use File::Compare qw(compare_text);

my @files = qw(
    bin/app.pl
    config.yml
    environments/development.yml
    environments/production.yml
    lib/Project/Name.pm
    Makefile.PL
    MANIFEST
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
    public/javascripts/jquery.js
    t/001_base.t
    t/002_index_route.t
    views/index.tt
    views/layouts/main.tt
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
