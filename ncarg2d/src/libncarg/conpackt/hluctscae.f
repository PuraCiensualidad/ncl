C
C $Id: hluctscae.f,v 1.1 2003-05-28 15:44:36 kennison Exp $
C
C                Copyright (C)  2000
C        University Corporation for Atmospheric Research
C                All Rights Reserved
C
C This file is free software; you can redistribute it and/or modify
C it under the terms of the GNU General Public License as published
C by the Free Software Foundation; either version 2 of the License, or
C (at your option) any later version.
C
C This software is distributed in the hope that it will be useful, but
C WITHOUT ANY WARRANTY; without even the implied warranty of
C MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
C General Public License for more details.
C
C You should have received a copy of the GNU General Public License
C along with this software; if not, write to the Free Software
C Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
C USA.
C
      SUBROUTINE HLUCTSCAE (ICRA,ICA1,ICAM,ICAN,XCPF,YCPF,XCQF,YCQF,
     +                                          IND1,IND2,ICAF,IAID)
C
      DIMENSION ICRA(ICA1,*)
C
C This routine stands between CONPACKT and the user call-back routine
C CTSCAE.  When HLUs are not in use, this version of the routine gets
C loaded, so that CTSCAE is called.  When HLUs are in use, another
C version gets loaded; it either does the appropriate thing for the
C purposes of the HLUs or calls CTSCAE.
C
      CALL CTSCAE (ICRA,ICA1,ICAM,ICAN,XCPF,YCPF,XCQF,YCQF,
     +                                 IND1,IND2,ICAF,IAID)
C
      RETURN
C
      END
