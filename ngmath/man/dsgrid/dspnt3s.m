.\"
.\"     $Id: dspnt3s.m,v 1.2 1997-09-29 22:15:12 fred Exp $
.\"
.TH DSPNT3S 3NCARG "September 1997" UNIX "NCAR GRAPHICS"
.SH NAME
DSPNT3S- Interpolate at a single point (or points) in 3D in single precision
.SH SYNOPSIS
CALL DSPNT3S (N, X, Y, Z, U, M, XO, YO, ZO, UO, IER)
.SH DESCRIPTION
.IP N 12
(Integer, Input) - The number of input data points. 
.IP X 12
(Real, Input) - An array containing the X coordinates of the 
input data points. 
.IP Y 12
(Real, Input) - An array containing the Y coordinates of the 
input data points.
.IP Z 12
(Real, Input) - An array containing the Z coordinates of the 
input data points.
.IP U 12
(Real, Input) - An array containing the functional values of 
the input data points. That is, U(L) is the value of the input
function at coordinate (X(L),Y(L),Z(L)), for L=1,N.
.IP M 12
(Integer, Input) - The number of output data points (this may be "1"). 
.IP XO 12
(Real, Input) - An array of dimension M containing 
the X coordinates of the output data. The values in XO may be in any order.
.IP YO 12
(Real, Input) - An array of dimension M containing 
the Y coordinates of the output data. The values in YO may be in any order.
.IP ZO 12
(Real, Input) - An array of dimension M containing 
the Z coordinates of the output data. The values in ZO may be in any order.
.IP UO 12
(Real, output) - An array of dimension M containing 
the interpolated values. UO(I) is the interpolated value at 
point (XO(I),YO(I),ZO(I)) for I=1,M. 
.IP IER 12
(Integer, Output) - An error return value. If IER is returned as 0, then
no errors were detected. If IER is non-zero, then refer to the man
page for dsgrid_errors for details.
.SH USAGE
This subroutine is called when you want to interpolate at an individual
point or points.
.SH ACCESS
To use DSPNT3S, load the NCAR Graphics library ngmath.
.SH SEE ALSO
dsgrid,
dsgrid_params.
.sp
Complete documentation for Dsgrid is available at URL
.br
http://ngwww.ucar.edu/ngdoc/ng/ngmath/dsgrid/dshome.html
.SH COPYRIGHT
Copyright (C) 1997
.br
University Corporation for Atmospheric Research
.br
The use of this Software is governed by a License Agreement.
