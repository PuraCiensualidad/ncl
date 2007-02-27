.\"
.\"	$Id: gqtxal.m,v 1.14 2007-02-27 18:20:20 haley Exp $
.\"
.TH GQTXAL 3NCARG "March 1993" UNIX "NCAR GRAPHICS"
.SH NAME
GQTXAL (Inquire text alignment) - retrieves the horizontal and vertical
text alignments.
.SH SYNOPSIS
CALL GQTXAL (ERRIND, TXALH, TXALV)
.SH C-BINDING SYNOPSIS
#include <ncarg/gks.h>
.sp
void ginq_text_align(Gint *err_ind, Gtext_align *text_align);
.SH DESCRIPTION
.IP ERRIND 12
(Integer, Output) - If the inquired values cannot be returned correctly,
a non-zero error indicator is returned in ERRIND, otherwise a zero is returned.
Consult "User's Guide for NCAR GKS-0A Graphics" for a description of the
meaning of the error indicators.
.IP TXALH 12
(Real, Output) - Returns the current horizontal text alignment:
.RS
.IP 0 
Normal (default)
.IP 1 
Left
.IP 2 
Center
.IP 3 
Right
.RE
.IP TXALV 12
(Real, Output) - Returns the current vertical text alignment:
.RS
.IP 0 
Normal (default)
.IP 1 
Top
.IP 2 
Cap
.IP 3 
Half
.IP 4 
Base
.IP 5 
Bottom
.RE
.SH ACCESS
To use GKS routines, load the NCAR GKS-0A library ncarg_gks.
.SH SEE ALSO
Online: 
gtx, gstxp, gstxal, gstxfp, gschh, gschsp, gschup, 
gschxp, gscr, gstxci, gqtxp, gqtxal, gqtxfp, gqchh, 
gqchsp, gqchup, gqchxp, plotchar, ngdots, ginq_text_align
.sp
Hardcopy: 
User's Guide for NCAR GKS-0A Graphics;
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
