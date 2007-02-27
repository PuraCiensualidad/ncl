.TH RGBHLS 3NCARG "March 1993" UNIX "NCAR GRAPHICS"
.na
.nh
.SH NAME
RGBHLS - Converts a color specification given in the
Red, Green, Blue (RGB) color space to color values in the 
Hue, Lightness, Saturation (HLS) color space.
.SH SYNOPSIS
CALL RGBHLS (R, G, B, H, L, S)
.SH C-BINDING SYNOPSIS
#include <ncarg/ncargC.h>
.sp
void c_rgbhls (float r, float g, float b, float *h, 
.br
float *l, float *s)
.SH DESCRIPTION 
.IP R 12
(REAL, input, range [0.,1.]) 
represents
the red intensity component of the input point in RGB
color space.
.IP G 12
(REAL, input, range [0.,1.]) 
represents
the green intensity component of the input point in RGB
color space.
.IP B 12
(REAL, input, range [0.,1.]) 
represents
the blue intensity component of the input point in RGB
color space.
.IP H 12
(REAL, output, range [0.,360.) ) 
represents
the hue of the input point in HLS color space. A value
of (0.,0.,B) in the input space will result in a hue of
0. in the output space.
.IP L 12
(REAL, output, range [0.,100.]) 
represents
the lightness value of the input point in HLS color
space.  Lightness is a measure of the quantity of light - a
lightness of 0. is black, and a lightness of 100.
gives white. The pure hues occur at lightness value 50.
.IP S 12
(REAL, output, range [0.,100.]) 
represents
the saturation value of the input point in HLS color
space.  Saturation is a measure of how much white light
is mixed with the color. Saturation values of 0.
represent grays (with a gray value equal to the
lightness value L). Saturation values of 100. are fully
saturated colors. The hue is undefined when S=0.  The
fully saturated pure hues occur when S=100. and L=50.
The saturation value should be thought of as a
percentage.
.SH EXAMPLES
Use the ncargex command to see the following relevant
examples: 
tcolcv,
fcce02.
.SH C-BINDING DESCRIPTION
The C-binding argument descriptions are the same as the FORTRAN 
argument descriptions.
.SH ACCESS
To use RGBHLS or c_rgbhls, load the NCAR Graphics libraries ncarg, ncarg_gks,
and ncarg_c, preferably in that order.  
.SH MESSAGES
See the colconv man page for a description of all Colconv error
messages and/or informational messages.
.SH SEE ALSO
Online:
colconv,
hlsrgb,
hsvrgb,
rgbhsv,
rgbyiq,
yiqrgb,
ncarg_cbind.
.sp
Hardcopy:
NCAR Graphics Fundamentals, UNIX Version
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
