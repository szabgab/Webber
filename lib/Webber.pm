package Webber;
use Moo;
use MooX::Options;
use 5.010;

use Template;
use Path::Iterator::Rule;

use Cwd        qw(getcwd);
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

	my $path_to_skeleton = 'Skeleton';  # TODO and when the module is installed?
	my $rule = Path::Iterator::Rule->new;
	for my $file ( $rule->all( $path_to_skeleton ) ) {
		say $file;
	}

	#my $tt = Template->new({
	#	#INCLUDE_PATH => '/search/path',
	#	INTERPOLATE  => 0,
	#	POST_CHOMP   => 0,
	#	#PRE_PROCESS  => 'header',
	#	EVAL_PERL    => 0,
	#});
	#$tt->process($template, \%vars, $output, %options)

}


1;

