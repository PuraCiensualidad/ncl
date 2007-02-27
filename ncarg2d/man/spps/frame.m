.TH FRAME 3NCARG "March 1993" UNIX "NCAR GRAPHICS"
.na
.nh
.SH NAME
FRAME - advances to the next picture (in the case of CGM output), or
pauses in the window of most recent creation (for X11 output).
A mouse or key click in the window on pause will cause all
active workstations to be cleared.
.SH SYNOPSIS
CALL FRAME
.SH C-BINDING SYNOPSIS
#include <ncarg/ncargC.h>
.sp
void c_frame()
.SH USAGE
If a CGM workstation is open, a call to routine FRAME causes
an END_PICTURE CGM element to be generated.
If there are open X windows, it updates all
workstations and pauses in the window of most recent creation.
After a mouse click or a key click in the window on pause, all
workstations are cleared.
.sp
FRAME is most applicable to an environment with a single active
workstation.  When multiple workstations are used, the more
versatile NGPICT routine should be considered.  NGPICT includes
the option of issuing a "<READY>" prompt
when a window is on pause.
.sp
To use NGPICT to replace routine FRAME for a single CGM workstation use:
CALL NGPICT(WKID,1),
where WKID is the workstation ID for the metafile and the
second argument flags a CLEAR WORKSTATION.
.SH EXAMPLES
Use the ncargex command to see the following relevant examples: 
agex06
.SH ACCESS
To use FRAME or c_frame, load the NCAR Graphics libraries ncarg, ncarg_gks,
and ncarg_c, preferably in that order.
.SH SEE ALSO
Online:
sflush, ngpict, spps, spps_params, ncarg_cbind
.sp
Hardcopy:  
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
