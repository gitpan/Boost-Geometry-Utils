package Boost::Geometry::Utils;
{
  $Boost::Geometry::Utils::VERSION = '0.06';
}
# ABSTRACT: Bindings for the Boost Geometry library
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);

use XSLoader;
XSLoader::load('Boost::Geometry::Utils', $Boost::Geometry::Utils::VERSION);

our @EXPORT_OK = qw(polygon_to_wkt linestring_to_wkt wkt_to_multilinestring
    polygon linestring polygon_linestring_intersection
    polygon_multi_linestring_intersection
    point_within_polygon point_covered_by_polygon linestring_simplify);

sub polygon_to_wkt {
    sprintf 'POLYGON(%s)', join ',', map { sprintf '(%s)', join ',', map { join ' ', @$_ } @$_ } @_;
}

sub linestring_to_wkt {
    sprintf "MULTILINESTRING(%s)", join ',', map { sprintf '(%s)', join ',', map { join ' ', @$_ } @$_ } @_;
}

sub wkt_to_multilinestring {
    return [] if $_[0] eq 'MULTILINESTRING()';
    $_[0] =~ s/^MULTILINESTRING\(\(//;
    $_[0] =~ s/\)\)$//;
    [ map [ map [ split / / ], split /,/ ], split /\),\(/, $_[0] ];
}

sub polygon {
    _polygon(\@_);
}

sub linestring {
    _multi_linestring(\@_)
}

sub multi_linestring {
    _multi_linestring(\@_)
}

1;


__END__
=pod

=head1 NAME

Boost::Geometry::Utils - Bindings for the Boost Geometry library

=head1 VERSION

version 0.06

=head1 SYNOPSIS

    use Boost::Geometry::Utils qw(polygon linestring polygon_linestring_intersection);
    
    my $square = [  # ccw
        [10, 10],
        [20, 10],
        [20, 20],
        [10, 20],
    ];
    my $hole_in_square = [  # cw
        [14, 14],
        [14, 16],
        [16, 16],
        [16, 14],
    ];
    my $polygon = polygon($square, $hole_in_square);
    my $linestring = linestring([ [5, 15], [30, 15] ]);
    
    my $intersection = polygon_linestring_intersection($polygon, $linestring);
    
    # $intersection is:
    # [
    #     [ [10, 15], [14, 15] ],
    #     [ [16, 15], [20, 15] ],
    # ]

=head1 ABSTRACT

This module provides bindings to perform some geometric operations using
the Boost Geometry library. It does not aim at providing full bindings
for such library, and that's why I left the I<Boost::Geometry> namespace
free. I'm unsure about the optimal architectural for providing full 
bindings, but I'm interested in such a project -- so, if you have ideas
please get in touch with me.

B<Warning:> the API could change in the future.

=head1 METHODS

=head2 polygon

Converts one or more arrayref(s) of points to a Boost Geometry polygon 
structure. Note that a Boost Geometry polygon is actually a polygon
with holes.

=head2 linestring

Converts an arrayref of points to a Boost Geometry linestring.

=head2 multi_linestring

Converts an arrayref of arrayrefs of points to a Boost Geometry multilinestring.

=head2 polygon_linestring_intersection

Performs an intersection between the supplied polygon and linestring,
and returns an arrayref of linestrings (represented as arrayrefs of
points).
Note that such an intersection is also called I<clipping>.

=head2 polygon_multi_linestring_intersection

Same as I<polygon_linestring_intersection> but it accepts a multilinestring
object to perform multiple clippings in a single batch.

=head2 polygon_to_wkt

Converts one or more arrayref(s) of points to a WKT representation of
a polygon (with holes).

=head2 linestring_to_wkt

Converts an arrayref of points to a WKT representation of a multilinestring.

=head2 wkt_to_multilinestring

Parses a MULTILINESTRING back to a Perl data structure.

=head2 linestring_simplify

Accepts an arrayref of points representing a linestring and a numeric tolerance 
and returns an arrayref of points representing the simplified linestring.

=head2 point_covered_by_polygon

Accepts a point and an arrayref of points representing a polygon and returns true 
or false according to the 'cover_by' strategy.

=head2 point_within_polygon

Accepts a point and an arrayref of points representing a polygon and returns true 
or false according to the 'within' strategy.

=head1 ACKNOWLEDGEMENTS

Thanks to mauke and mst (Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>)
for their valuable help in getting this to compile under Windows (MinGW) too.
Thanks to Mark Hindness for his work on data types conversion.

=head1 AUTHOR

Alessandro Ranellucci <aar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Alessandro Ranellucci.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

