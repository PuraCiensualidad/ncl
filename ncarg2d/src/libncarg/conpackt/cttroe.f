C
C $Id: cttroe.f,v 1.1 2003-05-28 15:44:35 kennison Exp $
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
      SUBROUTINE CTTROE (XCRA,YCRA,NCRA,OFFS,RWRK,IOCF,IAMA,IGID,IAIL,
     +                                                           IAIR)
C
      DIMENSION XCRA(*),YCRA(*),RWRK(12),IAMA(*)
C
C The routine CTTROE is given the (fractional) X and Y coordinates of
C points defining a curve C.  It generates a curve C' which is parallel
C to C and separated from it by a small distance.  The points defining
C C' are passed on to the routine CTWLAM, which clips them against a
C rectangular window (defined by the contents of the common block
C WDCOMN) and passes the visible portions on to AREDAM for insertion
C in an area map.
C
C XCRA and YCRA are X and Y coordinate arrays defining NCRA points that
C define part of the curve C.  OFFS is the distance, in the fractional
C coordinate system, from C to C'; if OFFS is positive, C' is to the
C left of C and, if OFFS is negative, C' is to the right of C.  RWRK is
C a workspace array, dimensioned 12, in which required information can
C be saved from call to call.  (It is expected, for a given curve,
C that the last point in one call will be the first point in the next
C call; if the curve is closed, it is expected that the last point in
C the last call will match the first point in the first call.  Still,
C we need to save the next-to-last point from each call for use during
C the next call and, if the curve is closed, we need to save the second
C and third points from the first call for use during the last call.
C We also need to save the last offset curve point generated by each
C call except the last. The saves could be done using local SAVEd
C variables, but that would preclude generating curves for positive
C and negative values of OFFS at the same time.)  IOCF is a flag of
C the form
C
C     4 * R + 2 * S + T
C
C where R, S, and T are one-bit flags giving information about the part
C of C defined by the call.  R = 0 says that (XCRA(NCRA),YCRA(NCRA))
C is not the last point of C and R = 1 says that it is.  S = 0 says that
C (XCRA(1),YCRA(1)) is the first point of the curve and S = 1 says that
C it is not.  T = 0 says that C is open on both ends, in which case its
C ends are to be extended to intersect the edges of the plotter frame,
C and T = 1 says that C is closed on itself.  IAMA is an area map array.
C IGID is the group identifier and IAIL and IAIR are the left and right
C area identifiers to be passed on to CTWLAM and eventually to AREDAM.
C IGID must be the same for all calls defining a given curve, but IAIL
C and IAIR may change from call to call.
C
C Note that, in the sequence of calls to CTTROE for a particular curve,
C IOCF takes on values like the following:
C
C     0  =>  Beginning of an open curve.
C     1  =>  Beginning of a closed curve.
C     2  =>  Part of an open curve, not including either end point.
C     3  =>  Part of a closed curve, not including either end point.
C     4  =>  An entire open curve, including both end points.
C     5  =>  An entire closed curve, including both end points.
C     6  =>  End of an open curve.
C     7  =>  End of a closed curve.
C
C First, extract individual flags from IOCF.  IBEG says whether or not
C the curve begins with this call, IEND says whether or not the curve
C ends with this call, and ICLO says whether or not the curve is closed.
C
      IBEG=1-MOD(IOCF/2,2)
      IEND=IOCF/4
      ICLO=MOD(IOCF,2)
C
C Initialize the flag that tells CTWLAM whether it just got a first
C point or not.
C
      IFST=0
C
C Initialize XNXT and YNXT for one particular case (when the first call
C defining a closed curve defines just the first two points of it).
C
      XNXT=1.E36
      YNXT=1.E36
C
C Initialize the variables that hold local copies of the left and right
C area identifiers.
C
      JAIL=IAIL
      JAIR=IAIR
C
C Do necessary initialization.
C
      IF (IBEG.NE.0) THEN
        ICRA=1
        XCPB=XCRA(1)
        YCPB=YCRA(1)
        XCPC=XCRA(2)
        YCPC=YCRA(2)
        IF (ICLO.EQ.0) THEN
          DIRE=0.
          ASSIGN 101 TO IJMP
          GO TO 201
        ELSE
          RWRK(1)=XCRA(2)
          RWRK(2)=YCRA(2)
          RWRK(5)=REAL(IAIL)
          RWRK(6)=REAL(IAIR)
          IF (NCRA.GE.3) THEN
            RWRK(3)=XCRA(3)
            RWRK(4)=YCRA(3)
          ELSE
            RWRK(3)=1.E36
            RWRK(4)=1.E36
          END IF
        END IF
      ELSE
        IF (RWRK(3).EQ.1.E36) THEN
          RWRK(3)=XCRA(2)
          RWRK(4)=YCRA(2)
        END IF
        IF (RWRK(9).NE.1.E36) THEN
          XNXT=RWRK(9)
          YNXT=RWRK(10)
          JAIL=INT(RWRK(11))
          JAIR=INT(RWRK(12))
          CALL CTWLAM (XNXT,YNXT,IFST,IAMA,IGID,JAIL,JAIR)
          IF (ICFELL('CTTROE',1).NE.0) RETURN
          IFST=1
        END IF
        ICRA=0
        XCPB=RWRK(7)
        YCPB=RWRK(8)
        XCPC=XCRA(1)
        YCPC=YCRA(1)
      END IF
C
C Generate offset points near the point with index ICRA until ICRA
C becomes equal to NCRA.
C
  101 ASSIGN 102 TO IJMP
C
  102 ICRA=ICRA+1
      IF (ICRA.LT.NCRA) THEN
        XCPA=XCPB
        YCPA=YCPB
        XCPB=XCPC
        YCPB=YCPC
        XCPC=XCRA(ICRA+1)
        YCPC=YCRA(ICRA+1)
        GO TO 301
      END IF
C
C Do necessary final stuff.
C
      IF (IEND.EQ.0) THEN
        RWRK( 7)=XCRA(NCRA-1)
        RWRK( 8)=YCRA(NCRA-1)
        RWRK( 9)=XNXT
        RWRK(10)=YNXT
        RWRK(11)=REAL(IAIL)
        RWRK(12)=REAL(IAIR)
        GO TO 104
      ELSE
        IF (ICLO.EQ.0) THEN
          DIRE=1.
          ASSIGN 104 TO IJMP
          GO TO 201
        ELSE
          XCPA=XCPB
          YCPA=YCPB
          XCPB=XCPC
          YCPB=YCPC
          XCPC=RWRK(1)
          YCPC=RWRK(2)
          ASSIGN 103 TO IJMP
          GO TO 301
        END IF
      END IF
C
  103 XCPA=XCPB
      YCPA=YCPB
      XCPB=XCPC
      YCPB=YCPC
      XCPC=RWRK(3)
      YCPC=RWRK(4)
      JAIL=INT(RWRK(5))
      JAIR=INT(RWRK(6))
      ASSIGN 104 TO IJMP
      GO TO 301
C
C Done.
C
  104 RETURN
C
C The following internal procedure generates the point of intersection
C of the line offset from BC with the edge of the plotter frame and
C sends that point off to CTWLAM.  DIRE says whether we want the point
C of intersection nearer to B (DIRE = 0.) or nearer to C (DIRE = 1.).
C
  201 XDBC=XCPC-XCPB
      YDBC=YCPC-YCPB
      DFBC=SQRT(XDBC*XDBC+YDBC*YDBC)
      XCPP=XCPB-OFFS*YDBC/DFBC
      YCPP=YCPB+OFFS*XDBC/DFBC
      XCPQ=XCPC-OFFS*YDBC/DFBC
      YCPQ=YCPC+OFFS*XDBC/DFBC
      IF (ABS(XDBC).GT.ABS(YDBC)) THEN
        IF (XDBC.GT.0.) THEN
          XNXT=DIRE
        ELSE
          XNXT=1.-DIRE
        END IF
        YNXT=YCPP+(XNXT-XCPP)*(YDBC/XDBC)
      ELSE
        IF (YDBC.GT.0.) THEN
          YNXT=DIRE
        ELSE
          YNXT=1.-DIRE
        END IF
        XNXT=XCPP+(YNXT-YCPP)*(XDBC/YDBC)
      END IF
      CALL CTWLAM (XNXT,YNXT,IFST,IAMA,IGID,IAIL,IAIR)
      IF (ICFELL('CTTROE',2).NE.0) RETURN
      IFST=1
      GO TO IJMP , (101,104)
C
C The following internal procedure generates the point of intersection
C of the line offset from AB with the line offset from BC and sends that
C point off to CTWLAM.
C
  301 XDAB=XCPB-XCPA
      YDAB=YCPB-YCPA
      DFAB=SQRT(XDAB*XDAB+YDAB*YDAB)
      XCPP=XCPA-OFFS*YDAB/DFAB
      YCPP=YCPA+OFFS*XDAB/DFAB
      XCPQ=XCPB-OFFS*YDAB/DFAB
      YCPQ=YCPB+OFFS*XDAB/DFAB
      XDBC=XCPC-XCPB
      YDBC=YCPC-YCPB
      DFBC=SQRT(XDBC*XDBC+YDBC*YDBC)
      XCPR=XCPB-OFFS*YDBC/DFBC
      YCPR=YCPB+OFFS*XDBC/DFBC
      XCPS=XCPC-OFFS*YDBC/DFBC
      YCPS=YCPC+OFFS*XDBC/DFBC
      DNOM=(XCPP-XCPQ)*(YCPR-YCPS)-(XCPR-XCPS)*(YCPP-YCPQ)
      IF (DNOM.EQ.0.) THEN
        XNXT=.5*(XCPQ+XCPR)
        YNXT=.5*(YCPQ+YCPR)
      ELSE
        TEMP=((XCPP-XCPR)*(YCPR-YCPS)-(XCPR-XCPS)*(YCPP-YCPR))/DNOM
        XNXT=XCPP+(XCPQ-XCPP)*TEMP
        YNXT=YCPP+(YCPQ-YCPP)*TEMP
      END IF
      CALL CTWLAM (XNXT,YNXT,IFST,IAMA,IGID,JAIL,JAIR)
      IF (ICFELL('CTTROE',3).NE.0) RETURN
      IFST=1
      JAIL=IAIL
      JAIR=IAIR
      GO TO IJMP , (102,103,104)
C
      END
