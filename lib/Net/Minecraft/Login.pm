use v5.16;
use warnings;

package Net::Minecraft::Login {

  # ABSTRACT: Basic implementation of the Minecraft Login Protocol.

=head1 DESCRIPTION

This is a basic implementation of the Minecraft Login protocol as described at L<http://wiki.vg/Session#Login>

  use Net::Minecraft::Login;

  my $ua = Net::Minecraft::Login->new();

  my $result = $ua->login(
    user => 'Bob',
    password => 'secret',
  );
  if( $result->isa('Net::Minecraft::LoginFailure') ){
    die $result;
  }
  say "Login for user " . $result->user . " succeeded";

Note, it presently does no explict session stuff, only performs the basic HTTP Request and returns the response as an object.


=cut

  use Moo;
  use Carp qw( confess );
  use Scalar::Util qw( blessed );
  use HTTP::Tiny;
  use Params::Validate qw( validate SCALAR );
  use Net::Minecraft::LoginResult;
  use Net::Minecraft::LoginFailure;

=head1 CONSTRUCTOR ARGUMENTS

This second describes arguments that may be optionally passed to L<<< C<< ->new() >>|/new >>>, but as of the time of this writing, none are explicitly required,
and are offered only to give leverage to strange usecases ( and tests )

  my $instance = Net::Minecraft::Login->new(
    user_agent   => ... ,
    http_headers => { ... },
    http_engine  => HTTP::Tiny->new(),
    login_server => 'https://somewhere.else.org/'
    version      => 14, # IN THE FUTURE!
  );

=carg user_agent

The User Agent to self-describe over HTTP

  type    : String
  default : "Net::Minecraft::Login/" . VERSION

=attr user_agent

=cut

  has user_agent => (
    is      => rwp =>,
    lazy    => 1,
    default => sub {
      my $class = $_[0];
      $class = blessed($class) if blessed($class);
      my $version = $class->VERSION;
      $version = 'DEVEL' if not defined $version;
      return sprintf q{%s/%s}, $class, $version;
    },
  );

=carg http_headers

Standard Headers that will be injected in each request

  type    : Hash[ string => string ]
  default : { 'Content-Type' => 'application/x-www-form-urlencoded' }

=attr http_headers

=cut

  has http_headers => ( is => rwp =>, lazy => 1, default => sub { { 'Content-Type' => 'application/x-www-form-urlencoded' } }, );

=carg http_engine

Low-Level HTTP Transfer Agent.

  type    : Object[ =~ HTTP::Tiny ]
  default : An HTTP::Tiny instance.

=attr http_engine

=cut

  has http_engine => ( is => rwp =>, lazy => 1, default => sub { return HTTP::Tiny->new( agent => $_[0]->user_agent ) }, );

=carg login_server

HTTP Address to authenticate with.

  type  : String
  default : https://login.minecraft.net/

=attr login_server

=cut

  has login_server => ( is => rwp =>, lazy => 1, default => sub { return 'https://login.minecraft.net/' }, );

=carg version

"Client" version.

  type  : String
  default : 13

This field indicates the version of the "Launcher". Minecraft may at some future time produce an updated launcher, and indicate that this specified version is out of date.

Mojang Minecraft Launchers will be required to download a newer version, and users of Net::Minecraft::Login will either

=over 4

=item a) Be required to update to a newer Net::Minecraft::Login that supports the newer version and changes that implies

=item b) Assuming no Login Protocol Changes, only have to specify C<< version => >> either to the constructor, or as an argument to L</login>

=back

=attr version

=cut

  ## no critic ( ProhibitMagicNumbers )
  has version => ( is => rwp =>, lazy => 1, default => sub { 13 }, );

=pmethod _do_request

  signature : ( String $base_uri, Hash[ String => String ] $parameters , Hash[ String => Any ] $config )
  return    : Hash[ String => String ]

=cut

  sub _do_request {
    my ( $self, $base_uri, $parameters, $config ) = @_;
    my $uri = sprintf q{%s?%s}, $base_uri, $self->http_engine->www_form_urlencode($parameters);
    return $self->http_engine->request( GET => $uri, $config );

  }

=method login

  signature: { user => String , password => String, version? => String }
  return   : Any( Net::Minecraft::LoginResult , Net::Minecraft::LoginFailure )

  my $result = $nmcl->login(
    user   => 'notch',
    password => 'jellybean',
  );

  if( $result->isa('Net::Minecraft::LoginFailure') ){
    say "$result";
  } else {
    say "Logged in!";
  }

See L<< C<::LoginFailure>|Net::Minecraft::LoginFailure >> and L<< C<::LoginResult>|Net::Minecraft::LoginResult >>

=cut

  sub login {
    my ( $self, @args ) = @_;
    my %params = validate(
      @args => {
        user     => { type => SCALAR },
        password => { type => SCALAR },
        version  => { type => SCALAR, default => $self->version },
      }
    );
    my $result = $self->_do_request( $self->login_server, \%params, { headers => $self->http_headers }, );
    if ( not $result->{success} ) {
      my $failure = Net::Minecraft::LoginFailure->new(
        code   => $result->{status},
        reason => $result->{reason},
      );
      return $failure;
    }
    return Net::Minecraft::LoginResult->parse( $result->{content} );
  }
};
1;
