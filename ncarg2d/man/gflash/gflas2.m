.TH GFLAS2 3NCARG "March 1993" UNIX "NCAR GRAPHICS"
.na
.nh
.SH NAME
GFLAS2 - Terminates putting plotting
instructions to disk and resumes putting plotting instructions
to the metafile output. A call to GFLAS2 can only be made after
a previous call to GFLAS1.
.SH SYNOPSIS
CALL GFLAS2 
.SH C-BINDING SYNOPSIS
#include <ncarg/ncargC.h>
.sp
void c_gflas2() 
.SH DESCRIPTION
None.
.SH EXAMPLES
Use the ncargex command to see the following relevant
example: 
tgflas.
.SH ACCESS
To use GFLAS2, load the NCAR Graphics libraries ncarg, ncarg_gks,
ncarg_c, and ncarg_loc, preferably in that order.  To use c_gflas2, load 
the NCAR Graphics libraries ncargC, ncarg_gksC, ncarg, ncarg_gks,
ncarg_c, and ncarg_loc, preferably in that order.
.SH SEE ALSO
Online:
gflash,
gflas1,
gflas3,
gflas4,
ncarg_cbind.
.SH COPYRIGHT
Copyright 1987, 1988, 1989, 1991, 1993 University Corporation
for Atmospheric Research
.br
All Rights Reserved
