package main;

use strict;
use warnings;

use Astro::SpaceTrack;
use HTTP::Response;
use Test::More 0.96;	# For subtest

use lib qw{ inc };
use My::Module::Test;

my $desired_content_interface = 2;
# my $rslt;
my $space_track_domain = 'www.space-track.org';
my $st;

# Things to search for.
my $search_date = '2012-06-13';
my $start_epoch = '2012/04/01';

{
    my $skip;
    $skip = site_check $space_track_domain	# To make sure we have account
	and plan skip_all	=> $skip;

    $st = Astro::SpaceTrack->new(
	identity	=> ! $ENV{SPACETRACK_USER},
	verify_hostname	=> VERIFY_HOSTNAME,
    );

    $st->set( space_track_version => $desired_content_interface );
}

## my $username = $st->getv( 'username' );
## my $password = $st->getv( 'password' );

SKIP: {

    is_success $st, 'login', 'Log in to Space-Track'
	or skip 'Not logged in', 1;

    my $rslt = HTTP::Response->new();

    not_defined $st->content_type(), 'Content type should be undef'
	or diag( 'content_type is ', $st->content_type() );

    not_defined $st->content_source(), 'Content source should be undef'
	or diag( 'content_source is ', $st->content_source() );

    not_defined $st->content_interface(),
	    'Content interface should be undef'
	or diag 'content_interface is ', $st->content_interface();

    not_defined $st->content_type( $rslt ), 'Result type should be undef'
	or diag( 'content_type is ', $st->content_type() );

    not_defined $st->content_source( $rslt ),
	    'Result source should be undef'
	or diag( 'content_source is ', $st->content_source( $rslt ) );

    not_defined $st->content_interface( $rslt ),
	    'Result interface should be undef'
	or diag 'content_interface is ', $st->content_interface( $rslt );

    is_error $st, spacetrack => 'fubar',
	404, 'Fetch a non-existent catalog entry';

    is_success $st, spacetrack => 'inmarsat',
	'Fetch a catalog entry';

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, retrieve => 25544, 'Retrieve ISS orbital elements';

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, file => 't/file.dat',
	'Retrieve orbital elements specified by file';

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, retrieve => '25544-25546',
	'Retrieve a range of orbital elements';

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_name => 'zarya', "Search for name 'zarya'";

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_name => -notle => 'zarya',
	"Search for name 'zarya', but only retrieve search results";

    is $st->content_type(), 'search', "Content type is 'search'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_id => '98067A', "Search for ID '98067A'";

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_id => -notle => '98067A',
	"Search for ID '98067A', but only retrieve search results";

    is $st->content_type(), 'search', "Content type is 'search'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_oid => 25544, "Search for OID 25544";

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_oid => -notle => 25544,
	"Search for OID 25544, but only retrieve search results";

    is $st->content_type(), 'search', "Content type is 'search'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_decay => '2010-1-10',
	'Search for bodies decayed January 10 2010';

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_decay => -notle => '2010-1-10',
	'Search for bodies decayed Jan 10 2010, but only retrieve search results';

    is $st->content_type(), 'search', "Content type is 'search'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_date => $search_date,
	"Search for date '$search_date'";

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, search_date => -notle => $search_date,
	"Search for date '$search_date', but only retrieve search results";

    is $st->content_type(), 'search', "Content type is 'search'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, retrieve => -start_epoch => $start_epoch, 25544,
	"Retrieve ISS orbital elements for epoch $start_epoch";

    is $st->content_type(), 'orbit', "Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, 'box_score', 'Retrieve satellite box score';

    is $st->content_type(), 'box_score',
	"Content type is 'box_score'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, spacetrack_query_v2 => qw{ basicspacedata query
	class tle_latest NORAD_CAT_ID 25544 },
	'Get ISS data via general query';

    is $st->content_type(), 'orbit',
	"Content type is 'orbit'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, spacetrack_query_v2 => qw{ basicspacedata modeldef
	class tle_latest },
	'Get tle_latest model definition';

    is $st->content_type(), 'modeldef',
	"Content type is 'modeldef'";

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, 'country_names', 'Retrieve country names';

    is $st->content_type(), 'country_names',
	q{Content type is 'country_names'};

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    is_success $st, 'launch_sites', 'Retrieve launch sites';

    is $st->content_type(), 'launch_sites',
	q{Content type is 'launch_sites'};

    is $st->content_source(), 'spacetrack',
	"Content source is 'spacetrack'";

    is $st->content_interface(), $desired_content_interface,
	"Content version is $desired_content_interface";

    SKIP: {
	my $skip;
	$skip = site_check 'celestrak.com'
	    and skip $skip, 1;

	is_success $st, celestrak => 'stations', 'Fetch Celestrak stations';

	is $st->content_type(), 'orbit', "Content type is 'orbit'";

	is $st->content_source(), 'spacetrack', "Content source is 'spacetrack'";

	is $st->content_interface(), $desired_content_interface,
	    "Content version is $desired_content_interface";

	$st->set( fallback => 1 );

	is_success $st, celestrak => 'stations',
	    'Fetch Celestrak stations with fallback';

	is $st->content_type(), 'orbit', "Content type is 'orbit'";

	is $st->content_source(), 'spacetrack', "Content source is 'spacetrack'";

	is $st->content_interface(), $desired_content_interface,
	    "Content version is $desired_content_interface";

	$st->set( username => undef, password => undef );

	is_success $st, celestrak => 'stations',
	    'Fetch Celestrak stations with fallback, without account';

	is $st->content_type(), 'orbit', "Content type is 'orbit'";

	is $st->content_source(), 'celestrak', "Content source is 'celestrak'";

	not_defined $st->content_interface(),
	    'Content version is not defined';

	$st->set( fallback => 0 );

	is_not_success $st, celestrak => 'stations',
	    'Fetch Celestrak stations without fallback or account fails';

    }

}

done_testing;

1;

__END__

#! ex: set textwidth=72 :
