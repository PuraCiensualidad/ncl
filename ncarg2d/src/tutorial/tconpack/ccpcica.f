	PROGRAM CCPCIC
        PARAMETER (NLON=361,NLAT=181,LRWK=5000,LIWK=5000,
     +                                 ICAM=512,ICAN=512)
        REAL ZDAT(NLON,NLAT),RWRK(LRWK)
        INTEGER IASF(13),IWRK(LIWK),ICRA(ICAM,ICAN)
        DATA IASF / 13*1 /
C
C Open GKS, turn clipping off, and set up GKS flags
C
        CALL OPNGKS
        CALL GSCLIP (0)
        CALL GSASF (IASF)
C
C Set up a color table
C
	CALL COLOR
C
C Create some data
C
	CALL MKDAT (2,ZDAT,NLON,NLAT)
C
C Zero cell array
C
	DO 10 I=1,ICAM
	   DO 20 J=1,ICAN
	      ICRA(I,J)=0
 20	   CONTINUE
 10	CONTINUE
C
C Setup a map
C
	CALL SETMAP ('SV',40.,-105.)
C
C Setup contour options
C
	CALL SETCTR (0,1,-180.,180.,-90.,90.,1.E36)
C
C Initialize Conpack
C
	CALL CPRECT (ZDAT,NLON,NLON,NLAT,RWRK,LRWK,IWRK,LIWK)
C
C Set cell array values and map it to user coordinates
C
        CALL CPCICA (ZDAT,RWRK,IWRK,ICRA,ICAM,ICAM,ICAN,0.,0.,1.,1.)
C
C Draw cell array and flush buffer
C
        CALL GCA (CFUX(0.),CFUY(0.),CFUX(1.),CFUY(1.),ICAM,ICAN,1,1,
     +                                               ICAM,ICAN,ICRA)
        CALL SFLUSH
C
C Draw contour lines
C
	CALL GSPLCI (0)
	CALL CPCLDR (ZDAT,RWRK,IWRK)
	CALL SFLUSH
C
C Draw Map
C
	CALL GSPLCI (1)
	CALL GSLWSC (3.)
	CALL MAPLOT
	CALL GSLWSC (1.)
	CALL MAPGRD
	CALL SFLUSH
C
C Draw title
C
	CALL SET (0.,1.,0.,1.,0.,1.,0.,1.,1)
	CALL GSPLCI (1)
	CALL PLCHHQ (.5,.95,'Cell Array in Conpack',.03,0.,0.)
C
C Close Frame and GKS
C
	CALL FRAME
	CALL CLSGKS

	STOP
	END

	SUBROUTINE MKDAT(NCTFR,ZDAT,NLON,NLAT)
C
C Create some data to contour
C
	REAL ZDAT(NLON,NLAT)
C
C NCTFR is used to generate a random number, ZDAT is the data array
C
	CALL GGDINI (0.,1.,NCTFR,.9)
	ZMIN= 1.E36
	ZMAX=-1.E36
	DO 10 I=1,NLON
	   RLON=.017453292519943*(-180.+360.*REAL(I-1)/REAL(NLON-1))
	   DO 20 J=1,NLAT
	      RLAT=.017453292519943*(-90.+180.*REAL(J-1)/REAL(NLAT-1))
	      ZDAT(I,J)=GGDPNT(RLAT,RLON)+.5*COS(4.*RLAT)
	      ZMIN=MIN(ZMIN,ZDAT(I,J))
	      ZMAX=MAX(ZMAX,ZDAT(I,J))
 20	   CONTINUE
 10	CONTINUE
	DO 30 I=1,NLON
	   DO 40 J=1,NLAT
	      ZDAT(I,J)=((ZDAT(I,J)-ZMIN)/(ZMAX-ZMIN))*130.-10.
 40	   CONTINUE
 30	CONTINUE
	DO 50 I=175,185
	   DO 60 J=85,95
	      ZDAT(I,J)=1.E36
 60	   CONTINUE
 50	CONTINUE
	
	RETURN
	END

	SUBROUTINE SETMAP (PTYPE,PLAT,PLON)
C
C Set up a map projection with desired options, but don't draw it.
C
        CHARACTER*2 PTYPE

        CALL MAPPOS (.05,.90,.05,.90)
        CALL MAPROJ (PTYPE,PLAT,PLON,0.)
        CALL MAPSET ('MA - MAXIMAL AREA',0.,0.,0.,0.)
        CALL MAPINT

	RETURN
	END

	SUBROUTINE SETCTR (ISET,MAPFLG,XMIN,XMAX,YMIN,YMAX,SPVAL)
C
C Set up Conpack options, but don't do anything
C
	CALL CPSETI ('SET - DO-SET-CALL FLAG',ISET)
	CALL CPSETI ('MAP - MAPPING FLAG',MAPFLG)
	CALL CPSETR ('XC1 - X COORDINATE AT I=1',XMIN)
	CALL CPSETR ('XCM - X COORDINATE AT I=M',XMAX)
	CALL CPSETR ('YC1 - Y COORDINATE AT J=1',YMIN)
	CALL CPSETR ('YCN - Y COORDINATE AT J=N',YMAX)
	CALL CPSETI ('CLS - CONTOUR LEVEL SELECTOR',1)
	CALL CPSETR ('CMN - CONTOUR LEVEL MINIMUM',0.)
	CALL CPSETR ('CMX - CONTOUR LEVEL MAXIMUM',110.)
	CALL CPSETR ('CIS - CONTOUR INTERVAL SPECIFIER',10.)
	CALL CPSETR ('ORV - OUT-OF-RANGE VALUE',1.E12)
	CALL CPSETR ('SPV - SPECIAL VALUE',SPVAL)
	CALL CPSETI ('CAF - CELL ARRAY FLAG',2)
	CALL CPSETI ('PAI - PARAMETER ARRAY INDEX',-1)
	CALL CPSETI ('AIA - AREA IDENTIFIER OUTSIDE THE GRID',-100)
	CALL CPSETI ('PAI - PARAMETER ARRAY INDEX',-2)
	CALL CPSETI ('AIA - AREA IDENTIFIER - SPECIAL-VALUE AREAS',-100)
	CALL CPSETI ('LLP - LINE LABEL POSITIONING',0)
	CALL CPSETC ('HLT - HIGH/LOW TEXT',' '' ')
*	CALL CPSETC ('ILT - INFORMATIONAL LABEL TEXT',' ')

	RETURN
	END
	SUBROUTINE COLOR
	CALL GSCR (1, 0,0.000,0.000,0.000)
	CALL GSCR (1, 1,1.000,1.000,1.000)
	CALL GSCR (1, 2,0.500,1.000,1.000)
	DO 10 I=3,15
          CALL GSCR (1,I,MAX(0.,MIN(1.,1.-REAL(ABS(I- 3)/10.))),
     +                   MAX(0.,MIN(1.,1.-REAL(ABS(I- 9)/10.))),
     +                   MAX(0.,MIN(1.,1.-REAL(ABS(I-15)/10.))))
 10	CONTINUE
	CALL GSCR (1,16,1.,0.,0.)
	RETURN
	END

      SUBROUTINE GGDINI (DLOW,DHGH,NRND,FRCT)
        PARAMETER (NELA=5,MFCE=27300,MEDG=40950,MVTX=10242,NELP=NELA+1)
        COMMON /GGDCMN/ NFCE,IFCE(4,MFCE),NEDG,IEDG(4,MEDG),
     +                  NVTX,VRTX(4,MVTX),
     +                  LFCE(2,NELP),LEDG(2,NELP),LVTX(2,NELP),
     +                  RLOW,RHGH,RMIN,RMAX
        SAVE   /GGDCMN/
        DIMENSION JFCE(3,20),JEDG(2,30),XCVI(12),YCVI(12),ZCVI(12)
        DATA JFCE(1, 1),JFCE(2, 1),JFCE(3, 1) /  1,11, 2 /
        DATA JFCE(1, 2),JFCE(2, 2),JFCE(3, 2) /  2,19, 3 /
        DATA JFCE(1, 3),JFCE(2, 3),JFCE(3, 3) /  3,25, 4 /
        DATA JFCE(1, 4),JFCE(2, 4),JFCE(3, 4) /  4,29, 5 /
        DATA JFCE(1, 5),JFCE(2, 5),JFCE(3, 5) /  1,14, 5 /
        DATA JFCE(1, 6),JFCE(2, 6),JFCE(3, 6) / 12,28,14 /
        DATA JFCE(1, 7),JFCE(2, 7),JFCE(3, 7) / 12,27,13 /
        DATA JFCE(1, 8),JFCE(2, 8),JFCE(3, 8) / 11,20,13 /
        DATA JFCE(1, 9),JFCE(2, 9),JFCE(3, 9) / 20,30,21 /
        DATA JFCE(1,10),JFCE(2,10),JFCE(3,10) / 19,26,21 /
        DATA JFCE(1,11),JFCE(2,11),JFCE(3,11) / 16,18,26 /
        DATA JFCE(1,12),JFCE(2,12),JFCE(3,12) / 16,25,17 /
        DATA JFCE(1,13),JFCE(2,13),JFCE(3,13) / 15,23,17 /
        DATA JFCE(1,14),JFCE(2,14),JFCE(3,14) / 23,29,24 /
        DATA JFCE(1,15),JFCE(2,15),JFCE(3,15) / 22,28,24 /
        DATA JFCE(1,16),JFCE(2,16),JFCE(3,16) /  7, 8,22 /
        DATA JFCE(1,17),JFCE(2,17),JFCE(3,17) /  6,15, 7 /
        DATA JFCE(1,18),JFCE(2,18),JFCE(3,18) /  6,18,10 /
        DATA JFCE(1,19),JFCE(2,19),JFCE(3,19) /  9,30,10 /
        DATA JFCE(1,20),JFCE(2,20),JFCE(3,20) /  8,27, 9 /
        DATA JEDG(1, 1),JEDG(2, 1) /  1, 3 /
        DATA JEDG(1, 2),JEDG(2, 2) /  1, 5 /
        DATA JEDG(1, 3),JEDG(2, 3) /  1, 7 /
        DATA JEDG(1, 4),JEDG(2, 4) /  1, 9 /
        DATA JEDG(1, 5),JEDG(2, 5) /  1,11 /
        DATA JEDG(1, 6),JEDG(2, 6) /  2, 4 /
        DATA JEDG(1, 7),JEDG(2, 7) /  2, 6 /
        DATA JEDG(1, 8),JEDG(2, 8) /  2, 8 /
        DATA JEDG(1, 9),JEDG(2, 9) /  2,10 /
        DATA JEDG(1,10),JEDG(2,10) /  2,12 /
        DATA JEDG(1,11),JEDG(2,11) /  3, 5 /
        DATA JEDG(1,12),JEDG(2,12) /  3, 8 /
        DATA JEDG(1,13),JEDG(2,13) /  3,10 /
        DATA JEDG(1,14),JEDG(2,14) /  3,11 /
        DATA JEDG(1,15),JEDG(2,15) /  4, 6 /
        DATA JEDG(1,16),JEDG(2,16) /  4, 7 /
        DATA JEDG(1,17),JEDG(2,17) /  4, 9 /
        DATA JEDG(1,18),JEDG(2,18) /  4,12 /
        DATA JEDG(1,19),JEDG(2,19) /  5, 7 /
        DATA JEDG(1,20),JEDG(2,20) /  5,10 /
        DATA JEDG(1,21),JEDG(2,21) /  5,12 /
        DATA JEDG(1,22),JEDG(2,22) /  6, 8 /
        DATA JEDG(1,23),JEDG(2,23) /  6, 9 /
        DATA JEDG(1,24),JEDG(2,24) /  6,11 /
        DATA JEDG(1,25),JEDG(2,25) /  7, 9 /
        DATA JEDG(1,26),JEDG(2,26) /  7,12 /
        DATA JEDG(1,27),JEDG(2,27) /  8,10 /
        DATA JEDG(1,28),JEDG(2,28) /  8,11 /
        DATA JEDG(1,29),JEDG(2,29) /  9,11 /
        DATA JEDG(1,30),JEDG(2,30) / 10,12 /
        DATA XCVI / .9510565162952 , -.9510565162951 ,  .4253254041760 ,
     +             -.4253254041760 ,  .4253254041760 , -.4253254041760 ,
     +              .4253254041760 , -.4253254041760 ,  .4253254041760 ,
     +             -.4253254041760 ,  .4253254041760 , -.4253254041760 /
        DATA YCVI / .0000000000000 ,  .0000000000000 ,  .8506508083520 ,
     +             -.8506508083520 ,  .2628655560596 , -.2628655560596 ,
     +             -.6881909602356 ,  .6881909602356 , -.6881909602356 ,
     +              .6881909602356 ,  .2628655560595 , -.2628655560596 /
        DATA ZCVI / .0000000000000 ,  .0000000000000 ,  .0000000000000 ,
     +              .0000000000000 ,  .8090169943749 , -.8090169943749 ,
     +              .5000000000000 , -.5000000000000 , -.5000000000000 ,
     +              .5000000000000 , -.8090169943749 ,  .8090169943749 /
        DATA DTOR / .017453292519943 /
        DATA RTOD / 57.2957795130823 /
      DO 19999 I=1,NRND
          TEMP=FRAN()
19999 CONTINUE
        NFCE=20
      DO 19998 I=1,NFCE
          IFCE(1,I)=JFCE(1,I)
          IFCE(2,I)=JFCE(2,I)
          IFCE(3,I)=JFCE(3,I)
          IFCE(4,I)=0
19998 CONTINUE
        NEDG=30
      DO 19997 I=1,NEDG
          IEDG(1,I)=JEDG(1,I)
          IEDG(2,I)=JEDG(2,I)
          IEDG(3,I)=0
          IEDG(4,I)=0
19997 CONTINUE
        NVTX=12
      DO 19996 I=1,NVTX
          TEMP=SQRT(XCVI(I)**2+YCVI(I)**2+ZCVI(I)**2)
          VRTX(1,I)=XCVI(I)/TEMP
          VRTX(2,I)=YCVI(I)/TEMP
          VRTX(3,I)=ZCVI(I)/TEMP
          VRTX(4,I)=FRAN()
19996 CONTINUE
        LFCE(1,1)=1
        LFCE(2,1)=NFCE
        LEDG(1,1)=1
        LEDG(2,1)=NEDG
        LVTX(1,1)=1
        LVTX(2,1)=NVTX
        RMUL=1.
      DO 19995 IELA=2,NELP
          LFCE(1,IELA)=NFCE+1
          LEDG(1,IELA)=NEDG+1
          LVTX(1,IELA)=NVTX+1
          RMUL=FRCT*RMUL
      DO 19994 I=LEDG(1,IELA-1),LEDG(2,IELA-1)
            NVTX=NVTX+1
            IF (NVTX.GT.MVTX) GO TO 901
            VRTX(1,NVTX)=.5*(VRTX(1,IEDG(1,I))+VRTX(1,IEDG(2,I)))
            VRTX(2,NVTX)=.5*(VRTX(2,IEDG(1,I))+VRTX(2,IEDG(2,I)))
            VRTX(3,NVTX)=.5*(VRTX(3,IEDG(1,I))+VRTX(3,IEDG(2,I)))
            VRTX(4,NVTX)=.5*(VRTX(4,IEDG(1,I))+VRTX(4,IEDG(2,I)))
            TEMP=SQRT(VRTX(1,NVTX)**2+VRTX(2,NVTX)**2+VRTX(3,NVTX)**2)
            VRTX(1,NVTX)=VRTX(1,NVTX)/TEMP
            VRTX(2,NVTX)=VRTX(2,NVTX)/TEMP
            VRTX(3,NVTX)=VRTX(3,NVTX)/TEMP
            NEDG=NEDG+2
            IF (NEDG.GT.MEDG) GO TO 902
            IEDG(3,I)=NEDG-1
            IEDG(4,I)=NEDG
            IEDG(1,NEDG-1)=IEDG(1,I)
            IEDG(2,NEDG-1)=NVTX
            IEDG(3,NEDG-1)=0
            IEDG(4,NEDG-1)=0
            IEDG(1,NEDG  )=NVTX
            IEDG(2,NEDG  )=IEDG(2,I)
            IEDG(3,NEDG  )=0
            IEDG(4,NEDG  )=0
19994 CONTINUE
      DO 19993 I=1,NVTX
            VRTX(4,I)=VRTX(4,I)+RMUL*FRAN()
19993 CONTINUE
      DO 19992 I=LFCE(1,IELA-1),LFCE(2,IELA-1)
            IFCE(4,I)=NFCE+1
            NEDG=NEDG+3
            IF (NEDG.GT.MEDG) GO TO 902
            IEDG(1,NEDG-2)=IEDG(2,IEDG(3,IFCE(1,I)))
            IEDG(2,NEDG-2)=IEDG(2,IEDG(3,IFCE(2,I)))
            IEDG(3,NEDG-2)=0
            IEDG(4,NEDG-2)=0
            IEDG(1,NEDG-1)=IEDG(2,IEDG(3,IFCE(2,I)))
            IEDG(2,NEDG-1)=IEDG(2,IEDG(3,IFCE(3,I)))
            IEDG(3,NEDG-1)=0
            IEDG(4,NEDG-1)=0
            IEDG(1,NEDG  )=IEDG(2,IEDG(3,IFCE(3,I)))
            IEDG(2,NEDG  )=IEDG(2,IEDG(3,IFCE(1,I)))
            IEDG(3,NEDG  )=0
            IEDG(4,NEDG  )=0
            NFCE=NFCE+4
            IF (NFCE.GT.MFCE) GO TO 903
      IF (.NOT.(IEDG(1,IFCE(1,I)).EQ.IEDG(1,IFCE(2,I)))) GO TO 19991
      IF (.NOT.(IEDG(2,IFCE(1,I)).EQ.IEDG(1,IFCE(3,I)))) GO TO 19990
                IFCE(1,NFCE-3)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(3,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(4,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(3,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(1,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
      GO TO 19989
19990 CONTINUE
                IFCE(1,NFCE-3)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(3,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(3,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(4,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
19989 CONTINUE
      GO TO 19988
19991 CONTINUE
      IF (.NOT.(IEDG(1,IFCE(1,I)).EQ.IEDG(2,IFCE(2,I)))) GO TO 19987
      IF (.NOT.(IEDG(2,IFCE(1,I)).EQ.IEDG(1,IFCE(3,I)))) GO TO 19986
                IFCE(1,NFCE-3)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(3,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(1,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
      GO TO 19985
19986 CONTINUE
                IFCE(1,NFCE-3)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(3,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(4,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
19985 CONTINUE
      GO TO 19988
19987 CONTINUE
      IF (.NOT.(IEDG(1,IFCE(1,I)).EQ.IEDG(1,IFCE(3,I)))) GO TO 19984
      IF (.NOT.(IEDG(2,IFCE(1,I)).EQ.IEDG(1,IFCE(2,I)))) GO TO 19983
                IFCE(1,NFCE-3)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(1,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(4,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(3,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
      GO TO 19982
19983 CONTINUE
                IFCE(1,NFCE-3)=IEDG(4,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(3,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
19982 CONTINUE
      GO TO 19988
19984 CONTINUE
      IF (.NOT.(IEDG(2,IFCE(1,I)).EQ.IEDG(1,IFCE(2,I)))) GO TO 19981
                IFCE(1,NFCE-3)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(1,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(3,I))
                IFCE(2,NFCE-2)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
      GO TO 19980
19981 CONTINUE
                IFCE(1,NFCE-3)=IEDG(4,IFCE(1,I))
                IFCE(2,NFCE-3)=IEDG(4,IFCE(2,I))
                IFCE(3,NFCE-3)=NEDG-2
                IFCE(4,NFCE-3)=0
                IFCE(1,NFCE-2)=IEDG(3,IFCE(2,I))
                IFCE(2,NFCE-2)=IEDG(3,IFCE(3,I))
                IFCE(3,NFCE-2)=NEDG-1
                IFCE(4,NFCE-2)=0
                IFCE(1,NFCE-1)=IEDG(3,IFCE(1,I))
                IFCE(2,NFCE-1)=IEDG(4,IFCE(3,I))
                IFCE(3,NFCE-1)=NEDG
                IFCE(4,NFCE-1)=0
19980 CONTINUE
19988 CONTINUE
            IFCE(1,NFCE  )=NEDG-2
            IFCE(2,NFCE  )=NEDG-1
            IFCE(3,NFCE  )=NEDG
            IFCE(4,NFCE  )=0
19992 CONTINUE
          LFCE(2,IELA)=NFCE
          LEDG(2,IELA)=NEDG
          LVTX(2,IELA)=NVTX
19995 CONTINUE
        RLOW=DLOW
        RHGH=DHGH
        RMIN=+1.E36
        RMAX=-1.E36
      DO 19979 I=1,NVTX
          RMIN=MIN(RMIN,VRTX(4,I))
          RMAX=MAX(RMAX,VRTX(4,I))
19979 CONTINUE
        RETURN
  901   PRINT * , 'STOP IN GGDINI - TOO MANY VERTICES'
        STOP
  902   PRINT * , 'STOP IN GGDINI - TOO MANY EDGES'
        STOP
  903   PRINT * , 'STOP IN GGDINI - TOO MANY FACES'
        STOP
      END
      FUNCTION GGDPNT (RLAT,RLON)
        PARAMETER (NELA=5,MFCE=27300,MEDG=40950,MVTX=10242,NELP=NELA+1)
        COMMON /GGDCMN/ NFCE,IFCE(4,MFCE),NEDG,IEDG(4,MEDG),
     +                  NVTX,VRTX(4,MVTX),
     +                  LFCE(2,NELP),LEDG(2,NELP),LVTX(2,NELP),
     +                  RLOW,RHGH,RMIN,RMAX
        SAVE   /GGDCMN/
        DATA DTOR / .017453292519943 /
        DATA RTOD / 57.2957795130823 /
        X0=COS(RLAT)*COS(RLON)
        Y0=COS(RLAT)*SIN(RLON)
        Z0=SIN(RLAT)
        IFST=1
        NUMB=20
        ITRY=1
19999 CONTINUE
          IPOS=IFST
19998 CONTINUE
            X1=VRTX(1,IEDG(1,IFCE(1,IPOS)))
            Y1=VRTX(2,IEDG(1,IFCE(1,IPOS)))
            Z1=VRTX(3,IEDG(1,IFCE(1,IPOS)))
            W1=VRTX(4,IEDG(1,IFCE(1,IPOS)))
            X2=VRTX(1,IEDG(2,IFCE(1,IPOS)))
            Y2=VRTX(2,IEDG(2,IFCE(1,IPOS)))
            Z2=VRTX(3,IEDG(2,IFCE(1,IPOS)))
            W2=VRTX(4,IEDG(2,IFCE(1,IPOS)))
      IF (.NOT.(IEDG(1,IFCE(2,IPOS)).NE.IEDG(1,IFCE(1,IPOS)).AND.IEDG(1,
     +IFCE(2,IPOS)).NE.IEDG(2,IFCE(1,IPOS)))) GO TO 19997
              X3=VRTX(1,IEDG(1,IFCE(2,IPOS)))
              Y3=VRTX(2,IEDG(1,IFCE(2,IPOS)))
              Z3=VRTX(3,IEDG(1,IFCE(2,IPOS)))
              W3=VRTX(4,IEDG(1,IFCE(2,IPOS)))
      GO TO 19996
19997 CONTINUE
              X3=VRTX(1,IEDG(2,IFCE(2,IPOS)))
              Y3=VRTX(2,IEDG(2,IFCE(2,IPOS)))
              Z3=VRTX(3,IEDG(2,IFCE(2,IPOS)))
              W3=VRTX(4,IEDG(2,IFCE(2,IPOS)))
19996 CONTINUE
            A1=Y3*Z2-Y2*Z3
            B1=X2*Z3-X3*Z2
            C1=X3*Y2-X2*Y3
            A2=Y1*Z3-Y3*Z1
            B2=X3*Z1-X1*Z3
            C2=X1*Y3-X3*Y1
            A3=Y2*Z1-Y1*Z2
            B3=X1*Z2-X2*Z1
            C3=X2*Y1-X1*Y2
      IF (.NOT.(ITRY.EQ.1)) GO TO 19995
              XM=(X1+X2+X3)/3.
              YM=(Y1+Y2+Y3)/3.
              ZM=(Z1+Z2+Z3)/3.
              S1=SIGN(1.,A1*XM+B1*YM+C1*ZM)
              S2=SIGN(1.,A2*XM+B2*YM+C2*ZM)
              S3=SIGN(1.,A3*XM+B3*YM+C3*ZM)
              T1=SIGN(1.,A1*X0+B1*Y0+C1*Z0)
              T2=SIGN(1.,A2*X0+B2*Y0+C2*Z0)
              T3=SIGN(1.,A3*X0+B3*Y0+C3*Z0)
      IF (S1.EQ.T1.AND.S2.EQ.T2.AND.S3.EQ.T3) GO TO 19994
      GO TO 19993
19995 CONTINUE
              D1=ABS(A1*X0+B1*Y0+C1*Z0)/SQRT(A1*A1+B1*B1+C1*C1)
              D2=ABS(A2*X0+B2*Y0+C2*Z0)/SQRT(A2*A2+B2*B2+C2*C2)
              D3=ABS(A3*X0+B3*Y0+C3*Z0)/SQRT(A3*A3+B3*B3+C3*C3)
              DIST=MIN(D1,D2,D3)
      IF (.NOT.(IBST.EQ.0.OR.DIST.LT.DBST)) GO TO 19992
                IBST=IPOS
                DBST=DIST
19992 CONTINUE
19993 CONTINUE
      IF (.NOT.(IPOS.EQ.IFST+NUMB-1)) GO TO 19991
      IF (.NOT.(ITRY.EQ.1)) GO TO 19990
                IPOS=IFST-1
                ITRY=2
                IBST=0
                DBST=0.
      GO TO 19989
19990 CONTINUE
                IPOS=IBST
                X1=VRTX(1,IEDG(1,IFCE(1,IPOS)))
                Y1=VRTX(2,IEDG(1,IFCE(1,IPOS)))
                Z1=VRTX(3,IEDG(1,IFCE(1,IPOS)))
                W1=VRTX(4,IEDG(1,IFCE(1,IPOS)))
                X2=VRTX(1,IEDG(2,IFCE(1,IPOS)))
                Y2=VRTX(2,IEDG(2,IFCE(1,IPOS)))
                Z2=VRTX(3,IEDG(2,IFCE(1,IPOS)))
                W2=VRTX(4,IEDG(2,IFCE(1,IPOS)))
      IF (.NOT.(IEDG(1,IFCE(2,IPOS)).NE.IEDG(1,IFCE(1,IPOS)).AND.IEDG(1,
     +IFCE(2,IPOS)).NE.IEDG(2,IFCE(1,IPOS)))) GO TO 19988
                  X3=VRTX(1,IEDG(1,IFCE(2,IPOS)))
                  Y3=VRTX(2,IEDG(1,IFCE(2,IPOS)))
                  Z3=VRTX(3,IEDG(1,IFCE(2,IPOS)))
                  W3=VRTX(4,IEDG(1,IFCE(2,IPOS)))
      GO TO 19987
19988 CONTINUE
                  X3=VRTX(1,IEDG(2,IFCE(2,IPOS)))
                  Y3=VRTX(2,IEDG(2,IFCE(2,IPOS)))
                  Z3=VRTX(3,IEDG(2,IFCE(2,IPOS)))
                  W3=VRTX(4,IEDG(2,IFCE(2,IPOS)))
19987 CONTINUE
      GO TO 19994
19989 CONTINUE
19991 CONTINUE
            IPOS=IPOS+1
      GO TO 19998
19994 CONTINUE
          IFST=IFCE(4,IPOS)
          NUMB=4
          ITRY=1
      IF (.NOT.(IFST.EQ.0)) GO TO 19999
      IF (.NOT.((X1-X0)**2+(Y1-Y0)**2+(Z1-Z0)**2.LT..000001))
     +GO TO 19986
          RVAL=W1
      GO TO 19985
19986 CONTINUE
          AP=Y1*(Z3-Z2)+Y2*(Z1-Z3)+Y3*(Z2-Z1)
          BP=X1*(Z2-Z3)+X2*(Z3-Z1)+X3*(Z1-Z2)
          CP=X1*(Y3-Y2)+X2*(Y1-Y3)+X3*(Y2-Y1)
          DP=X1*Y2*Z3-X1*Y3*Z2-X2*Y1*Z3+X3*Y1*Z2+X2*Y3*Z1-X3*Y2*Z1
          TP=-DP/(AP*X0+BP*Y0+CP*Z0)
          X4=TP*X0
          Y4=TP*Y0
          Z4=TP*Z0
          A1=Y3*Z2-Y2*Z3
          B1=X2*Z3-X3*Z2
          C1=X3*Y2-X2*Y3
          TP=-(A1*X1+B1*Y1+C1*Z1)/(A1*(X4-X1)+B1*(Y4-Y1)+C1*(Z4-Z1))
          X5=X1+TP*(X4-X1)
          Y5=Y1+TP*(Y4-Y1)
          Z5=Z1+TP*(Z4-Z1)
          W5=W2+(W3-W2)*SQRT(((X5-X2)**2+(Y5-Y2)**2+(Z5-Z2)**2)/
     +                       ((X3-X2)**2+(Y3-Y2)**2+(Z3-Z2)**2))
          RVAL=W1+(W5-W1)*SQRT(((X4-X1)**2+(Y4-Y1)**2+(Z4-Z1)**2)/
     +                         ((X5-X1)**2+(Y5-Y1)**2+(Z5-Z1)**2))
19985 CONTINUE
        GGDPNT=RLOW+(RHGH-RLOW)*(RVAL-RMIN)/(RMAX-RMIN)
        RETURN
      END
      FUNCTION FRAN()
        DOUBLE PRECISION X
        SAVE X
        DATA X / 2.718281828459045 /
        X=MOD(9821.D0*X+.211327D0,1.D0)
        FRAN=REAL(X)
        RETURN
      END
