package Webber;
use Moo;
use MooX::Options;
use 5.010;

use Template;
use Path::Iterator::Rule;

use Cwd        qw(getcwd);
use File::Path qw(mkpath);
#use Path::Tiny qw(path);


option name => (
	is       => 'ro',
	format   => 's',
	required => 1,
	doc      => 'Name of the application',
);
option path => (
	is       => 'ro',
	format   => 's',
	required => 0,
	default  => \&getcwd,
	doc => 'Path to directory where project should be created. Defaults to current working directory.',
);

sub run {
	my ($self) = @_;

	# check command line
	if ($self->name !~ /^[\w-]+$/) {
		die "--name must be a valid distribution name like  App-Name\n";
	}

	my $target_path = $self->path . '/' . $self->name;
	if (-e $target_path) {
		die "Path '$target_path' already exists.\n";
	}

	# create skeleton
	mkdir $target_path or die;

	my $tt = Template->new({
		#INCLUDE_PATH => '/search/path',
		INTERPOLATE  => 0,
		POST_CHOMP   => 0,
		#PRE_PROCESS  => 'header',
		EVAL_PERL    => 0,
	});

	my $module_name = $self->name;
	$module_name =~ s{-}{::}g;

	my $module_file = $self->name;
	$module_file =~ s{-}{/}g;
	$module_file = "lib/$module_file.pm";

	my %vars = (
		APPNAME           => $self->name,
		MAIN_MODULE_FILE  => $module_file,
	);

	my $path_to_skeleton = 'Skeleton';  # TODO and when the module is installed?
	my $rule = Path::Iterator::Rule->new;
	my $next = $rule->iter( $path_to_skeleton, { relative => 1 });
	while (my $file = $next->() ) {
		next if $file eq '.';

		my $src    = "$path_to_skeleton/$file";

		if ($file eq 'lib/Skeleton.pm') {
			$file = $module_file;
		}
		my $target = "$target_path/$file";

		if (-d $src) {
			mkpath $target or die;
		} else {
			$tt->process($src, \%vars, $target) or die;
		}
	}
}


1;

