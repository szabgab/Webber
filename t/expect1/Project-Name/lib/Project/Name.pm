package Project::Name;
use Dancer ':syntax';

our $VERSION = '0.01';

get '/' => sub {
    template 'index';
};

true;
