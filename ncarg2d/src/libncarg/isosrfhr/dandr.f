C
C       $Id: dandr.f,v 1.5 2006-03-10 23:56:10 kennison Exp $
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
      SUBROUTINE DANDR (NV,NW,ST1,LX,NX,NY,IS2,IU,S,IOBJS,MV)
      DIMENSION       ST1(NV,NW,2)           ,IS2(LX,NY) ,S(4)       ,
     1                IOBJS(MV,NW)
        REAL       PX(2),  PY(2)
C
C************** MACHINE DEPENDANT CONSTANTS ****************
C NBPW NUMBER OF BITS PER WORD
C MASK AN ARRAY NBPW LONG.  MASK(I)=2**(I-1), I=1,2,...,NBPW
C CDC 6000 OR 7000 VERSION
C
      DIMENSION       MASK(64)
C
        SAVE
        NBPW = I1MACH(5)
        DO 1 I = 1,NBPW
 1      MASK(I) = ISHIFT(1,I)
C
C THE FOLLOWING CALL IS FOR GATHERING STATISTICS ON LIBRARY USE AT NCAR
      CALL Q8QST4('GRAPHX','ISOSRFHR','DANDR','VERSION  1')
C
      NNV = NV
      NNW = NW
      LLX = LX
      NNX = NX
      NNY = NY
      IIU = IU
      IRET = 3
C
C RX AND RY ARE USED TO MAP PLOTTER COORDINATES INTO THE
C IMAGE PLANE MODEL.
C
      RX = (REAL(NNX)-1.)/(S(2)-S(1))
      RY = (REAL(NNY)-1.)/(S(4)-S(3))
C
C READ THE RELATIVE PLOTTER COORDINATES OF THE LATTICE
C POINTS FROM UNIT IU.
C
      READ (IIU) ST1
C
C DX, DY AND DZ ARE USED TO FIND REQUIRED COORDINATES OF
C NON-LATTICE POINTS.
C
      NVD2 = NNV/2
      NWD2 = NNW/2
      DX = (ST1(NNV,NWD2,1)-ST1(1,NWD2,1))*.5/(REAL(NNV)-1.)
      DY = (ST1(1,NWD2,2)-ST1(NNV,NWD2,2))*.5/(REAL(NNV)-1.)
      DZ = (ST1(NVD2,NNW,2)-ST1(NVD2,1,2))*.5/(REAL(NNW)-1.)
C
C SLOPE IS USED TO DEFORM THE IMAGE PLANE MODEL SO THAT
C LINES OF CONSTANT Y OF THE IMAGE MODEL HAVE THE SAME
C SLOPE AS LINES OF CONSTANT U AND W IN THE PICTURE.  THIS
C IMPROVES THE PICTURE.
C
      SLOPE = DY/DX
C
C THE FOLLOWING LOOPS THROUGH STATEMENT 12 GENERATE THE .5
C CONTOUR LINES IN 2-SPACE FOR THE ARRAY IOBJS (WHICH CON-
C TAINS ONLY ZEROES AND ONES), TESTS THE LINES FOR VISIBIL-
C ITY, AND CALLS A ROUTINE TO PLOT THE VISIBLE LINES.
C
      DO 213 I=2,NNV
         JUMP = IOBJS(I-1,1)*8+IOBJS(I,1)*4+1
         DO 212 J=2,NNW
            X = ST1(I,J,1)
            Y = ST1(I,J,2)
C
C DECIDE WHICH OF THE 16 POSSIBILITIES THIS IS.
C
            JUMP = (JUMP-1)/4+IOBJS(I-1,J)*8+IOBJS(I,J)*4+1
            GO TO (112,102,104,105,107,108,103,110,110,101,
     1             108,107,105,104,102,112),JUMP
C
C GOING TO 101 MEANS JUMP=10 WHICH MEANS ONLY THE LOWER-RIGHT
C AND UPPER-LEFT ELEMENTS OF THIS CELL ARE SET TO 1.
C TWO LINES SHOULD BE DRAWN, A DIAGONAL CONNECTING THE
C MIDDLE OF THE BOTTOM TO THE MIDDLE OF THE RIGHT SIDE OF
C THE CELL (LOWER-RIGHT LINE), AND A DIAGONAL CONNECTING THE
C MIDDLE OF THE LEFT SIDE TO THE MIDDLE OF THE TOP (UPPER-
C LEFT LINE) OF THE CELL.
C
  101       IRET = 2
C
C LOWER-RIGHT LINE
C
  102       X1 = X
            Y1 = Y-DZ
            X2 = X+DX
            Y2 = Y-DY
            GO TO 111
C
C LOWER-LEFT AND UPPER-RIGHT
C
  103       IRET = 1
C
C LOWER-LEFT
C
  104       X1 = X
            Y1 = Y-DZ
            X2 = X-DX
            Y2 = Y+DY
            GO TO 111
C
C HORIZONTAL
C
  105       X1 = X+DX
            Y1 = Y-DY
            X2 = X-DX
            Y2 = Y+DY
            GO TO 111
C
C UPPER-RIGHT
C
  106       IRET = 3
  107       X1 = X+DX
            Y1 = Y-DY
            X2 = X
            Y2 = Y+DZ
            GO TO 111
C
C VERTICAL
C
  108       X1 = X
            Y1 = Y-DZ
            X2 = X
            Y2 = Y+DZ
            GO TO 111
  109       IRET = 3
C
C UPPER-LEFT
C
  110       X1 = X-DX
            Y1 = Y+DY
            X2 = X
            Y2 = Y+DZ
C
C TEST VISIBILITY OF THIS LINE SEGMENT.
C
  111       IX = (X1-S(1))*RX
            IY = MOD(INT((Y1-S(3))*RY-SLOPE*REAL(IX))+NNY,NNY)+1
            IBIT = MOD(IX,NBPW)+1
            IX = IX/NBPW+1
            IV = IAND(IS2(IX,IY),MASK(IBIT))
C
C IF EITHER END OF THE LINE IS AT A MARKED SPOT ON THE IMAGE
C PLANE MODEL, THE LINE IS HIDDEN
C
            IF (IV .NE. 0) GO TO (106,109,112) , IRET
            IX = (X2-S(1))*RX
            IY = MOD(INT((Y2-S(3))*RY-SLOPE*REAL(IX))+NNY,NNY)+1
            IBIT = MOD(IX,NBPW)+1
            IX = IX/NBPW+1
            IV = IAND(IS2(IX,IY),MASK(IBIT))
            IF (IV .NE. 0) GO TO (106,109,112) , IRET
            PX(1) = CPUX(INT(X1))
            PX(2) = CPUX(INT(X2))
            PY(1) = CPUY(INT(Y1))
            PY(2) = CPUY(INT(Y2))
            CALL GPL (2,PX,PY)
            GO TO (106,109,112) , IRET
  112    CONTINUE
  212    CONTINUE
  113 CONTINUE
  213 CONTINUE
C
C CODE THROUGH STATEMENT 113 CREATES AN APPROXIMATION OF
C THE SILHOUETTE OF THE PART OF THE PICTURE JUST DRAWN BY
C MARKING THE IMAGE PLANE MODEL WHERE THE OBJECT OCCURS.
C
      DO 115 I=1,NNV
         DO 114 J=1,NNW
            IF (IOBJS(I,J) .EQ. 0) GO TO 114
            IX = (ST1(I,J,1)-S(1))*RX+0.5
            TWK = SLOPE*REAL(IX)-0.5
            IY = MOD(INT((ST1(I,J,2)-S(3))*RY-TWK)+NNY,NNY)+1
            IBIT = MOD(IX,NBPW)+1
            IX = IX/NBPW+1
            IS2(IX,IY) = IOR(IS2(IX,IY),MASK(IBIT))
  114    CONTINUE
  115 CONTINUE
      RETURN
C
C REVISION HISTORY---
C
C JANUARY 1978     DELETED REFERENCES TO THE  *COSY  CARDS AND
C                  ADDED REVISION HISTORY
C
C JULY    1984     CONVERTED TO STANDARD FORTRAN77 AND GKS
C
C-----------------------------------------------------------------------
      END
