C
C Define error file, Fortran unit number, and workstation type,
C and workstation ID.
C 
      PARAMETER (IERRF=6, LUNIT=2, IWTYPE=SED_WSTYPE, IWKID=1)
      
      PARAMETER (MREG=50,NREG=50)
      REAL XREG(MREG),YREG(NREG),ZREG(MREG,NREG)
      
      EXTERNAL COLOR
C
C Get data array
C
      CALL GETDAT(XREG,YREG,ZREG,MREG,NREG)
C
C Open GKS
C
      CALL GOPKS (IERRF, ISZDM)
      CALL GOPWK (IWKID, LUNIT, IWTYPE)
      CALL GACWK (IWKID)
C
C Call Conpack color fill routine
C
      
      CALL CCPLLB(ZREG,MREG,NREG,COLOR,IWKID)
C
C Close frame and close GKS
C
      CALL FRAME
      CALL GDAWK (IWKID)
      CALL GCLWK (IWKID)
      CALL GCLKS
      
      STOP
      END
      
      SUBROUTINE CCPLLB(ZREG,MREG,NREG,COLOR,IWKID)
      
      PARAMETER (LRWK=5000,LIWK=5000,LMAP=50000,NWRK=5000,NOGRPS=5)
      REAL ZREG(MREG,NREG),RWRK(LRWK), XWRK(NWRK), YWRK(NWRK)
      INTEGER MREG,NREG,IWRK(LIWK)
      INTEGER MAP(LMAP),IAREA(NOGRPS),IGRP(NOGRPS)
      
      EXTERNAL FILL
      EXTERNAL CPDRPL
      EXTERNAL COLOR
C
C Set fill style to solid and turn off clipping
C
      CALL GSFAIS(1)
      CALL GSCLIP(0)
C
C Make room at the bottom for the information label
C
      CALL CPSETR('VPB',0.1)
C
C Set up label box options
C
      CALL CPSETI('LLP',2)
      CALL CPSETI('LLB',1)
      CALL CPSETI('HLB',1)
      CALL CPSETI('ILB',1)
*     CALL CPSETR('LLW',.02)
      CALL CPSETR('HLW',0.)
      CALL CPSETR('ILW',.03)
C
C Initialize Conpack
C
      CALL CPRECT(ZREG, MREG, MREG, NREG, RWRK, LRWK, IWRK, LIWK)
C
C Set up color table
C
      CALL CPPKCL (ZREG, RWRK, IWRK)
      CALL CPGETI('NCL',NCL)
      CALL COLOR(NCL+1,IWKID)
C
C Draw Perimeter
C
      CALL CPBACK(ZREG, RWRK, IWRK)
C
C Initialize Areas
C
      CALL ARINAM(MAP, LMAP)
C
C Add label boxes to area map
C
      CALL CPLBAM(ZREG, RWRK, IWRK, MAP)
C
C Add contours to area map
C
      CALL CPCLAM(ZREG, RWRK, IWRK, MAP)
C
C Fill contours
C
      CALL ARSCAM(MAP, XWRK, YWRK, NWRK, IAREA, IGRP, NOGRPS, FILL)
C
C Draw Labels
C
      CALL CPLBDR(ZREG, RWRK, IWRK)
      
      RETURN
      END
      
      SUBROUTINE FILL (XWRK,YWRK,NWRK,IAREA,IGRP,NGRPS)
C 
      DIMENSION XWRK(*),YWRK(*),IAREA(*),IGRP(*)
      
      DO 10, I=1,NGRPS
         IF (IGRP(I).EQ.3) IAREA3=IAREA(I)
 10   CONTINUE
      
      IF (IAREA3 .GT. 0) THEN
C
C If the area is defined by 3 or more points, fill it
C
         CALL GSFACI(IAREA3+2)
         CALL GFA(NWRK,XWRK,YWRK)
      ENDIF
C
C Otherwise, do nothing
C
      RETURN
      END
      
      SUBROUTINE GETDAT(XREG,YREG,ZREG,MREG,NREG)
      
      PARAMETER (NRAN=30,LRWK=5000,LIWK=5000)
      INTEGER MREG, NREG
      REAL XRAN(NRAN), YRAN(NRAN), ZRAN(NRAN)
      REAL XREG(MREG), YREG(NREG), ZREG(MREG,NREG), RWRK(LRWK)
      INTEGER IWRK(LIWK)
      
      DATA XRAN /12., 60., 14., 33.,  8., 12., 43., 57., 22., 15.,
     1     19., 12., 64., 19., 15., 55., 31., 32., 33., 29.,
     2     18.,  1., 18., 42., 56.,  9.,  6., 12., 44., 19./
      DATA YRAN / 1.,  2.,  3., 53.,  7., 11., 13., 17., 19., 49.,
     1     1., 31., 37.,  5.,  7., 47., 61., 17.,  5., 23.,
     2     29.,  3.,  5., 41., 43.,  9., 13., 59.,  1., 67./
      DATA ZRAN /1.0, 1.5, 1.7, 1.4, 1.9, 1.0, 1.5, 1.2, 1.8, 1.4,
     1     1.8, 1.7, 1.9, 1.5, 1.2, 1.1, 1.3, 1.7, 1.2, 1.6,
     2     1.9, 1.0, 1.6, 1.3, 1.4, 1.8, 1.7, 1.5, 1.1, 1.0/
C 
C Set the min and max data values.
C 
      XMIN = 0.0
      XMAX = 65.0
      YMIN =  0.0
      YMAX = 68.0
C 
C Choose the X and Y coordinates for interpolation points on the 
C regular grid.
C 
      DO 101 I=1,MREG
         XREG(I)=XMIN + (XMAX - XMIN)* REAL(I-1)/MREG
 101  CONTINUE
C 
      DO 102 I=1,NREG
         YREG(I)=YMIN + (YMAX - YMIN)* REAL(I-1)/NREG
 102  CONTINUE
C
C Interpolate data onto a regular grid
C
      CALL IDSFFT (1,NRAN,XRAN,YRAN,ZRAN,
     +     MREG,NREG,MREG,XREG,YREG,ZREG,IWRK,RWRK)
      
      RETURN
      END
      SUBROUTINE COLOR (N,IWKID)
C
C Background color
C Black
C
      CALL GSCR(IWKID,0,0.,0.,0.)
C
C First foreground color is white
C
      CALL GSCR(IWKID,1,1.,1.,1.)
C
C Second foreground color is gray
C
      CALL GSCR(IWKID,2,.75,.75,.75)
C
C Choose other foreground colors spaced equally around the spectrum
C
      ICNT=0
      HUES=360./N
C
C REDLN is intended to be the line between red and violet values
C
      REDLN=36.0
      LAP=INT(REDLN/HUES)
C
      DO 10, I=1,N
         XHUE=I*HUES
         CALL HLSRGB(XHUE,60.,75.,RED,GREEN,BLUE)
C
C Sort colors so that the redest is first, and violetest is last
C
         IF (XHUE.LE.REDLN) THEN
            CALL GSCR(IWKID,(N+2)-(LAP-I),RED,GREEN,BLUE)
            ICNT=ICNT+1
         ELSE
            CALL GSCR(IWKID,I-ICNT+2,RED,GREEN,BLUE)
         ENDIF
 10   CONTINUE
      
      RETURN
      END
      
