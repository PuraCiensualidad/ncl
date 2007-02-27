.TH HAFTON 3NCARG "March 1993" UNIX "NCAR GRAPHICS"
.na
.nh
.SH NAME
HAFTON - draws a half-tone
picture from data stored in a rectangular array with the
intensity in the picture proportional to the data value.
.SH UTILITY
This routine is part of the Halftone utility in NCAR Graphics. To see
the overview man page for this utility, type "man halftone".
.SH STATUS
HAFTON is obsolete.  It has been replaced by the CPCICA entry of the
Conpack contouring package.
.sp
HAFTON continues to be provided for compatibility of early NCAR Graphics
codes.  If you are writing new code, we suggest that you use CPCICA.
.SH SYNOPSIS
CALL HAFTON (Z,L,M,N,FLO,HI,NLEV,NOPT,NPRM,ISPV,SPVAL)
.SH DESCRIPTION 
.IP Z 12
(an input array of type REAL) defining a two-dimensional field to be
half-tone plotted. A subset of Z of extent M by N can be plotted.
.IP L 12
(an input parameter of type INTEGER) which is the first dimension of
the Z array.
.IP M 12
(an input parameter of type INTEGER) which is the extent of the
first dimension of array Z to be plotted.  This allows for a sub-array
of Z to be plotted.  M must be less than or equal to L.
.IP N 12
(an input parameter of type INTEGER) which is the extent of the
second dimension of array Z to be plotted.  This allows for a sub-array
of Z to be plotted.  N must be less than or equal to the second dimension
of Z.
.IP FLO 12
(an input parameter of type REAL) defining a lowest level for plotting.
If FLO = HI = 0., the minimum value of Z will be
generated by HAFTON.
.IP HI 12
(an input parameter of type REAL) defining a highest level for plotting.
If HI = FLO = 0., the maximum value of Z will be
generated by HAFTON.
.IP NLEL 12
(an input parameter of type INTEGER) specifying the number of intensity
levels desired.  16 maximum.  If NLEV = 0 or 1, 16 levels
are used.
.IP NOPT 12
(an input parameter of type INTEGER) used
to control the mapping of Z onto the
intensities.  The sign of NOPT controls
the directness or inverseness of the
mapping.

NOPT positive yields direct mapping.
The largest value of Z produces the
most dense dots.  On mechanical plotters,
large values of Z will produce a dark
area on the paper.  With the film
development methods used at NCAR,
large values of Z will produce many
(white) dots on the film, also
resulting in a dark area on
reader-printer paper.

NOPT negative yields inverse mapping.
The smallest values of Z produce the
most dense dots resulting in dark
areas on the paper.

The absolute value of NOPT determines the
mapping of Z onto the intensities.  For
IABS(NOPT)

= 0  The mapping is linear.  For
     each intensity there is an equal
     range in Z value.

= 1  The mapping is linear.  For
     each intensity there is an equal
     range in Z value.

= 2  The mapping is exponential.  For
     larger values of Z, there is a
     larger difference in intensity for
     relatively close values of Z.  Details
     in the larger values of Z are displayed
     at the expense of the smaller values
     of Z.

= 3  The mapping is logarithmic, so
     details of smaller values of Z are show
     at the expense of larger values of Z.

= 4  Sinusoidal mapping, so mid-range values
     of Z show details at the expense of
     extreme values of Z.

= 5  Arcsine mapping, so extreme values of
     Z are shown at the expense of mid-range
.IP NPRM 12
(an input parameter of type INTEGER) used
to control the drawing of a
perimeter around the half-tone picture.

NPRM=0:  The perimeter is drawn with
ticks pointing at data locations.
(Side lengths are proportional to number
of data values.)

NPRM positive:  No perimeter is drawn.  The
picture fills the frame.

NPRM negative:  The picture is within the
confines of the user's current viewport
setting.
.IP ISPV 12
(an input parameter of type INTEGER) used
to tell if the special value feature
is being used.  The special value feature
is used to mark areas where the data is
not known or holes are wanted in the
picture.

ISPV = 0:  Special value feature not in
use.  SPVAL is ignored.

ISPV non-zero:  Special value feature
in use.  SPVAL defines the special
value.  Where Z contains the special
value, no half-tone is drawn.  If ISPV

= 0  Special value feature not in use.
     SPVAL is ignored.

= 1  Nothing is drawn in special value
     area.

= 2  Contiguous special value areas are
     surrounded by a polygonal line.

= 3  Special value areas are filled
     with X(s).

= 4  Special value areas are filled in
     with the highest intensity.
.IP SPVAL 12
(an iput parameter of type REAL) used to
denote missing values in the Z array.
This argument is ignored if ISPV = 0.
.SH ACCESS 
To use HAFTON, load the NCAR Graphics libraries ncarg, ncarg_gks,
and ncarg_c, preferably in that order.
.SH SEE ALSO
Online:
halftone, ezhftn, halftone_params,
conpack, conpack_params, cpcica
.sp
Hardcopy:  
NCAR Graphics Contouring and Mapping Tutorial;
NCAR Graphics Fundamentals, UNIX Version;
User's Guide for NCAR GKS-0A Graphics
.SH COPYRIGHT
Copyright (C) 1987-2007
.br
University Corporation for Atmospheric Research
.br

This documentation is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This software is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this software; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA.
