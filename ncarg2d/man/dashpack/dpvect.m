.TH DPVECT 3NCARG "March 1995" UNIX "NCAR GRAPHICS"
.na
.nh
.SH NAME
DPVECT - Specifies the second and following points in a sequence of points,
in the user coordinate system, defining a curve to be drawn.
.SH SYNOPSIS
CALL DPVECT (XCPU,YCPU)
.SH C-BINDING SYNOPSIS
#include <ncarg/ncargC.h>
.sp
void c_dpvect (float xcpu, float ycpu);
.SH DESCRIPTION 
.IP XCPU 12
(an input expression of type REAL) specifies the X coordinate of a point,
in the user coordinate system.
.IP YCPU 12
(an input expression of type REAL) specifies the Y coordinate of a point,
in the user coordinate system.
.SH C-BINDING DESCRIPTION
The C-binding argument descriptions are the same as the FORTRAN 
argument descriptions.
.SH USAGE
Call DPFRST to do a "pen-up" move to the first of a sequence of points
defining a curve.  Call DPVECT to do "pen-down" moves to each of the other
points in the sequence and then call DPLAST to finish drawing the curve
and flush the buffers.
.sp
DPVECT maps the input coordinates to the fractional coordinate system and
then does a "pen-down" call to either DPDRAW (if smoothing is turned off)
or to DPSMTH (if smoothing is turned on) with those coordinates.
.SH EXAMPLES
Use the ncargex command to see the following relevant
examples: 
tdshpk.
.SH ACCESS
To use DPVECT or c_dpvect, load the NCAR Graphics libraries ncarg, ncarg_gks,
and ncarg_c, preferably in that order.  
.SH SEE ALSO
Online:
dashpack,
dashpack_params,
dpcurv,
dpdraw,
dpfrst,
dpgetc,
dpgeti,
dpgetr,
dplast,
dpline,
dpsetc,
dpseti,
dpsetr,
dpsmth,
dpvect,
ncarg_cbind.
.sp
Hardcopy:
None.
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
