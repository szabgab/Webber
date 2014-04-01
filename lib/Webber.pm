package Webber;
use Moo;
use MooX::Options;
use 5.010;

use Template;
use Path::Iterator::Rule;

use Cwd            qw(getcwd);
use File::Path     qw(mkpath);
use File::ShareDir qw(dist_dir);

our $VERSION = '0.01';


option name => (
	is       => 'ro',
	format   => 's',
	required => 1,
	doc      => 'Name of the application. (e.g. Project::Name)',
);
option path => (
	is       => 'ro',
	format   => 's',
	required => 0,
	default  => \&getcwd,
	doc      => 'Path to directory where project should be created. Defaults to current working directory.',
);

sub run {
	my ($self) = @_;

	# check command line
	if ($self->name !~ /^[\w:]+$/) {
		die "--name must be a valid distribution name like  App::Name\n";
	}
	my $distro_name = $self->name;
	$distro_name =~ s{::}{-}g;

	my $target_path = $self->path . '/' . $distro_name;
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
		ABSOLUTE     => 1, # is needed only after installation
	});

	my $module_file = $self->name;
	$module_file =~ s{::}{/}g;
	$module_file = "lib/$module_file.pm";

	my %vars = (
		APPNAME           => $self->name,
		MAIN_MODULE_FILE  => $module_file,
		DISTRO_NAME       => $distro_name,
		TT_OPEN           => '[%',
		TT_CLOSE          => '%]',
	);

	my $path_to_skeleton = dist_dir('Webber') . "/Skeleton";

	# heuristics to see we are in the development environment:
	if (-e 'share' and -e 'lib/Webber.pm') {
		$path_to_skeleton = 'share/Skeleton';
	}

	my $rule = Path::Iterator::Rule->new;
	my $next = $rule->iter( $path_to_skeleton, { relative => 1 });
	while (my $file = $next->() ) {
		next if $file eq '.';
		next if $file =~ /\.swp$/;

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

