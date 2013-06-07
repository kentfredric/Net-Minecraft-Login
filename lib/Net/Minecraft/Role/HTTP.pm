use v5.16;
use warnings;
 
package Net::Minecraft::Role::HTTP {
BEGIN {
  $Net::Minecraft::Role::HTTP::AUTHORITY = 'cpan:KENTNL';
}

{
  $Net::Minecraft::Role::HTTP::VERSION = '0.001001';
}


    # ABSTRACT: Base class for minecrafty http things. 


    use Moo::Role;  
    use HTTP::Tiny;
    use Scalar::Util qw( blessed );


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


  has http_headers => ( is => rwp =>, lazy => 1, default => sub { { 'Content-Type' => 'application/x-www-form-urlencoded' } }, );


  has http_engine => ( is => rwp =>, lazy => 1, default => sub { return HTTP::Tiny->new( agent => $_[0]->user_agent ) }, );

}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Net::Minecraft::Role::HTTP - Base class for minecrafty http things. 

=head1 VERSION

version 0.001001

=head1 CONSTRUCTOR ARGUMENTS

=head2 user_agent

The User Agent to self-describe over HTTP

  type    : String
  default : "Net::Minecraft::Login/" . VERSION

=head2 http_headers

Standard Headers that will be injected in each request

  type    : Hash[ string => string ]
  default : { 'Content-Type' => 'application/x-www-form-urlencoded' }

=head2 http_engine

Low-Level HTTP Transfer Agent.

  type    : Object[ =~ HTTP::Tiny ]
  default : An HTTP::Tiny instance.

=head1 ATTRIBUTES

=head2 user_agent

=head2 http_headers

=head2 http_engine

=begin MetaPOD::JSON v1.0.0

{
    "namespace":"Net::Minecraft::Role::HTTP"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
