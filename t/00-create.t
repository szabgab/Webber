use strict;
use warnings;

use Test::More;
use File::Compare qw(compare);
#use File::Compare qw(compare_text);

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


plan tests => 1 + @files;

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

#diag $dir;

system "$^X -Ilib bin/webber --name Project-Name --path $dir";
ok(1);

foreach my $file (@files) {
	my $expected = "t/expect1/Project-Name/$file";
	my $received = "$dir/Project-Name/$file";
	ok(compare($received, $expected) == 0, $file);
	#ok(compare_text("$dir/$file", "t/expect1/$file", sub {
	#	if ($_[0] eq $_[1]) {
	#		return 0;
	#	} else {
	#		diag "fail";
	#		return 0;
	#	}
	#}) == 0, $file);
}
