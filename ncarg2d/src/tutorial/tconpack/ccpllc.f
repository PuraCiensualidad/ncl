	PROGRAM CCPLLC

C
C Define error file, Fortran unit number, and workstation type,
C and workstation ID.
C
        PARAMETER (IERRF=6, LUNIT=2, IWTYPE=SED_WSTYPE, IWKID=1)

        PARAMETER (LRWK=3500,LIWK=4000,LMAP=75000)
        PARAMETER (MREG=50,NREG=50)
	REAL X(MREG),Y(NREG),ZREG(MREG,NREG), RWRK(LRWK)
	INTEGER IWRK(LIWK), MAP(LMAP)

	EXTERNAL CPDRPL

	CALL GETDAT (X, Y, ZREG, MREG, NREG, RWRK, IWRK, LRWK, LIWK)
C Open GKS
        CALL GOPKS (IERRF, ISZDM)
        CALL GOPWK (IWKID, LUNIT, IWTYPE)
        CALL GACWK (IWKID)
C Initialize Areas
	CALL ARINAM(MAP,LMAP)
C Initialize Conpack
	CALL COLOR(IWKID)
	CALL CPRECT(ZREG, MREG, MREG, NREG, RWRK, LRWK, IWRK, LIWK)
	CALL CPPKCL(ZREG, RWRK, IWRK)
	CALL CPGETI('NCL - NUMBER OF CONTOUR LEVELS',NCONS)
	CALL CPSETI('LLP - LINE LABEL POSITIONING FLAG',2)
	CALL CPSETR('LLS - LINE LABEL SIZE',.02)
	CALL CPSETC('HLT - HIGH/LOW LABEL TEXT',' '' ')
	DO 11, I=1,NCONS
	   CALL CPSETI('PAI - PARAMETER ARRAY INDEX',I)
	   CALL CPSETI('CLU - CONTOUR LEVEL USE FLAG',3)
	   CALL CPSETI('LLC - LINE LABEL COLOR INDEX',MOD(I,16)+1)
 11	CONTINUE
C Draw Perimeter
	CALL CPBACK(ZREG, RWRK, IWRK)
C Add contours to area map
	CALL CPCLAM(ZREG,RWRK,IWRK,MAP)
C Add labels to area map
	CALL CPLBAM(ZREG,RWRK,IWRK,MAP)
C Draw contours and labels
	CALL CPCLDM(ZREG,RWRK,IWRK,MAP,CPDRPL)
	CALL CPLBDR(ZREG,RWRK,IWRK)

C Close frame and close GKS
	CALL FRAME
        CALL GDAWK (IWKID)
        CALL GCLWK (IWKID)
        CALL GCLKS

	STOP
	END

	SUBROUTINE GETDAT (X,Y,Z,M,N,RWRK,IWRK,LRWK,LIWK)

        PARAMETER (NRAN=30)

	REAL XRAN(NRAN), YRAN(NRAN), ZRAN(NRAN)
	REAL X(M), Y(N), Z(M,N), RWRK(LRWK)
	INTEGER IWRK(LIWK)

	DATA XRAN /12., 60., 14., 33.,  8., 12., 43., 57., 22., 15.,
     1		   19., 12., 64., 19., 15., 55., 31., 32., 33., 29.,
     2		   18.,  1., 18., 42., 56.,  9.,  6., 12., 44., 19./
	DATA YRAN / 1.,  2.,  3., 53.,  7., 11., 13., 17., 19., 49.,
     1		    1., 31., 37.,  5.,  7., 47., 61., 17.,  5., 23.,
     2		   29.,  3.,  5., 41., 43.,  9., 13., 59.,  1., 67./
	DATA ZRAN /1.0, 1.5, 1.7, 1.4, 1.9, 1.0, 1.5, 1.2, 1.8, 1.4,
     1		   1.8, 1.7, 1.9, 1.5, 1.2, 1.1, 1.3, 1.7, 1.2, 1.6,
     2		   1.9, 1.0, 1.6, 1.3, 1.4, 1.8, 1.7, 1.5, 1.1, 1.0/


C
C  Set the min and max data values.
C
      XMIN = 0.0
      XMAX = 65.0
      YMIN =  0.0
      YMAX = 68.0
C
C Choose the X and Y coordinates for interpolation points on the 
C regular grid.
C
      DO 101 I=1,M
        X(I)=XMIN + (XMAX - XMIN)* REAL(I-1)/M
  101 CONTINUE
C
      DO 102 I=1,N
        Y(I)=YMIN + (YMAX - YMIN)* REAL(I-1)/N
  102 CONTINUE

C Interpolate data onto a regular grid
	CALL IDSFFT (1,NRAN,XRAN,YRAN,ZRAN,M,N,M,X,Y,Z,IWRK,RWRK)

	RETURN
	END
      SUBROUTINE COLOR(IWKID)
C
C     BACKGROUND COLOR
C     BLACK
      CALL GSCR(IWKID,0,0.,0.,0.)
C
C     FORGROUND COLORS
C White
      CALL GSCR(IWKID,  1, 1.0, 1.0, 1.0)
C Aqua
      CALL GSCR(IWKID,  2, 0.0, 0.9, 1.0)
C Red
      CALL GSCR(IWKID,  3, 0.9, 0.25, 0.0)
C OrangeRed
      CALL GSCR(IWKID,  4, 1.0, 0.0, 0.2)
C Orange
      CALL GSCR(IWKID,  5, 1.0, 0.65, 0.0)
C Yellow
      CALL GSCR(IWKID,  6, 1.0, 1.0, 0.0)
C GreenYellow
      CALL GSCR(IWKID,  7, 0.7, 1.0, 0.2)
C Chartreuse
      CALL GSCR(IWKID,  8, 0.5, 1.0, 0.0)
C Celeste
      CALL GSCR(IWKID,  9, 0.2, 1.0, 0.5)
C Green
      CALL GSCR(IWKID, 10, 0.2, 0.8, 0.2)
C DeepSkyBlue
      CALL GSCR(IWKID, 11, 0.0, 0.75, 1.0)
C RoyalBlue
      CALL GSCR(IWKID, 12, 0.25, 0.45, 0.95)
C SlateBlue
      CALL GSCR(IWKID, 13, 0.4, 0.35, 0.8)
C DarkViolet
      CALL GSCR(IWKID, 14, 0.6, 0.0, 0.8)
C Orchid
      CALL GSCR(IWKID, 15, 0.85, 0.45, 0.8)
C Lavender
      CALL GSCR(IWKID, 16, 0.8, 0.8, 1.0)
C Gray
      CALL GSCR(IWKID, 17, 0.7, 0.7, 0.7)
C Done.
C
        RETURN
C
      END
