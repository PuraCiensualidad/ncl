C
C $Id: mapblm.f,v 1.7 1998-05-23 20:24:36 kennison Exp $
C
      SUBROUTINE MAPBLM (IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
C
      DIMENSION IAM(*),XCS(*),YCS(*),IAI(*),IAG(*)
C
C Declare required common blocks.
C
      COMMON /MAPCM1/ IPRJ,PHOC,IROD,RSNO,RCSO,RSNR,RCSR
      SAVE /MAPCM1/
C
      COMMON /MAPDP1/ DSNO,DCSO,DSNR,DCSR
      DOUBLE PRECISION DSNO,DCSO,DSNR,DCSR
      SAVE /MAPDP1/
C
      COMMON /MAPCM2/ UMIN,UMAX,VMIN,VMAX,UEPS,VEPS,UCEN,VCEN,URNG,VRNG,
     +                BLAM,SLAM,BLOM,SLOM,ISSL
      SAVE /MAPCM2/
C
      COMMON /MAPCM3/ ITPN,NOUT,NPTS,IGID,IDLS,IDRS,BLAG,SLAG,BLOG,SLOG,
     +                PNTS(200),IDOS(4)
      SAVE /MAPCM3/
C
      COMMON /MAPCM4/ INTF,JPRJ,PHIA,PHIO,ROTA,ILTS,PLA1,PLA2,PLA3,PLA4,
     +                PLB1,PLB2,PLB3,PLB4,PLTR,GRID,IDSH,IDOT,LBLF,PRMF,
     +                ELPF,XLOW,XROW,YBOW,YTOW,IDTL,GRDR,SRCH,ILCW,GRLA,
     +                GRLO,GRPO
      LOGICAL         INTF,LBLF,PRMF,ELPF
      SAVE /MAPCM4/
C
      COMMON /MAPCMC/ IGI1,IGI2,NOVS,XCRA(100),YCRA(100),NCRA
      SAVE /MAPCMC/
C
      COMMON /MAPSAT/ SALT,SSMO,SRSS,ALFA,BETA,RSNA,RCSA,RSNB,RCSB
      SAVE /MAPSAT/
C
C Define some required double-precision variables.
C
      DOUBLE PRECISION DR,DS,DCOSB,DSINB,DCOSA,DSINA,DCOSPH,DSINPH,
     +                 DCOSLA,DSINLA
C
C Define required constants.
C
      DATA DTOR / .017453292519943 /
      DATA RTOD / 57.2957795130823 /
C
C The arithmetic statement functions FLOOR and CLING give, respectively,
C the "floor" of X - the largest integer less than or equal to X - and
C the "ceiling" of X - the smallest integer greater than or equal to X.
C
      FLOOR(X)=REAL(DINT(DBLE(X)+1.D4)-1.D4)
      CLING(X)=-FLOOR(-X)
C
C Check for an uncleared prior error.
C
      IF (ICFELL('MAPBLM - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
C
C If EZMAP needs initialization, do nothing.
C
      IF (INTF) RETURN
C
C If the perimeter is to be drawn ...
C
      IF (.NOT.(PRMF)) GO TO 10000
C
C ... reset the color index and dash pattern for the perimeter ...
C
      CALL MAPCHM (1,IOR(ISHIFT(32767,1),1),
     +                              IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',2).NE.0) RETURN
C
C .. and draw the perimeter.
C
      IF (.NOT.(ELPF)) GO TO 10001
      TEMP=.9998
10002 CONTINUE
      U=URNG
      V=0.
      XCRD=UCEN+TEMP*U
      YCRD=VCEN
      L10004=    1
      GO TO 10004
10003 CONTINUE
      I = 1
      GO TO 10007
10005 CONTINUE
      I =I +1
10007 CONTINUE
      IF (I .GT.(360)) GO TO 10006
      U=URNG*COS(DTOR*FLOAT(I))
      V=URNG*SIN(DTOR*FLOAT(I))
      XCRD=UCEN+TEMP*U
      YCRD=VCEN+TEMP*V*VRNG/URNG
      L10009=    1
      GO TO 10009
10008 CONTINUE
      GO TO 10005
10006 CONTINUE
      IF (TEMP.EQ.1.0002) GO TO 10010
      TEMP=1.0002
      GO TO 10002
10010 CONTINUE
      GO TO 10011
10001 CONTINUE
      XCRD=UMIN
      YCRD=VMIN
      L10004=    2
      GO TO 10004
10012 CONTINUE
      XCRD=UMAX
      YCRD=VMIN
      L10009=    2
      GO TO 10009
10013 CONTINUE
      XCRD=UMAX
      YCRD=VMAX
      L10009=    3
      GO TO 10009
10014 CONTINUE
      XCRD=UMIN
      YCRD=VMAX
      L10009=    4
      GO TO 10009
10015 CONTINUE
      XCRD=UMIN
      YCRD=VMIN
      L10009=    5
      GO TO 10009
10016 CONTINUE
10011 CONTINUE
      L10018=    1
      GO TO 10018
10017 CONTINUE
C
C Restore the color index and dash pattern.
C
      CALL MAPCHM (-1,0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',3).NE.0) RETURN
C
10000 CONTINUE
C
C Reset the color index and dash pattern for limb lines.
C
      CALL MAPCHM (4,IOR(ISHIFT(32767,1),1),
     +                                IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',4).NE.0) RETURN
C
C Draw the limb line.
C
      GO TO (101,107,102,103,107,104,107,107,105,107,107,105) , IPRJ
C
  101 DLAT=GRDR
      RLON=PHOC+179.9999
      K=CLING(180./DLAT)
      DO 10019 I=1,2
      RLAT=-90.
      CALL MAPITM (RLAT,RLON,0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',5).NE.0) RETURN
      DO 10020 J=1,K-1
      RLAT=RLAT+DLAT
      CALL MAPITM (RLAT,RLON,1,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',6).NE.0) RETURN
10020 CONTINUE
      RLAT=RLAT+DLAT
      CALL MAPITM (RLAT,RLON,2,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',7).NE.0) RETURN
      RLON=PHOC-179.9999
10019 CONTINUE
      L10018=    2
      GO TO 10018
10021 CONTINUE
      GO TO 107
C
  102 CONTINUE
      IF (.NOT.(ABS(SALT).LE.1..OR.ALFA.EQ.0.)) GO TO 10022
      URAD=1.
      RVTU=1.
      GO TO 106
10022 CONTINUE
      SSLT=SALT
      SALT=-ABS(SALT)
      IF (.NOT.(IROD.EQ.0)) GO TO 10023
      R=.9998
10024 CONTINUE
      IPEN=0
      DO 10025 I=1,361
      RCOSB=COS(DTOR*REAL(I-1))
      RSINB=SIN(DTOR*REAL(I-1))
      IF (.NOT.(R.LT.1.)) GO TO 10026
      RCOSA=(R*R*ABS(SALT)+SSMO*SQRT(1.-R*R))/(R*R+SSMO)
      GO TO 10027
10026 CONTINUE
      S=2.-R
      RCOSA=(S*S*ABS(SALT)-SSMO*SQRT(1.-S*S))/(S*S+SSMO)
10027 CONTINUE
      RSINA=SQRT(1.-RCOSA*RCOSA)
      RSINPH=RSINA*RSINB
      RCOSPH=RCOSA*RCSO-RSINA*RSNO*RCOSB
      RCOSLA=SQRT(RSINPH*RSINPH+RCOSPH*RCOSPH)
      IF (.NOT.(RCOSLA.NE.0.)) GO TO 10028
      RSINPH=RSINPH/RCOSLA
      RCOSPH=RCOSPH/RCOSLA
10028 CONTINUE
      IF (.NOT.(ABS(RSNO).GT.1.E-4)) GO TO 10029
      RSINLA=(RCOSA-RCOSLA*RCOSPH*RCSO)/RSNO
      GO TO 10030
10029 CONTINUE
      RSINLA=RSINA*RCOSB
10030 CONTINUE
      RLAT=RTOD*ATAN2(RSINLA,RCOSLA)
      RLON=PHOC+RTOD*ATAN2(RSINA*RSINB,
     +                     RCOSA*RCSO-RSINA*RSNO*RCOSB)
      IF (ABS(RLON).GT.180.) RLON=RLON-SIGN(360.,RLON)
      CALL MAPITM (RLAT,RLON,IPEN,
     +             IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',8).NE.0) RETURN
      IPEN=1
      IF (I.EQ.360) IPEN=2
10025 CONTINUE
      L10018=    3
      GO TO 10018
10031 CONTINUE
      IF (R.EQ.1.0002) GO TO 10032
      R=1.0002
      GO TO 10024
10032 CONTINUE
      GO TO 10033
10023 CONTINUE
      DSALT=DBLE(ABS(SALT))
      DSSMO=DSALT*DSALT-1.D0
      DR=.9998D0
10034 CONTINUE
      IPEN=0
      DO 10035 I=1,361
      DCOSB=COS(DBLE(DTOR*REAL(I-1)))
      DSINB=SIN(DBLE(DTOR*REAL(I-1)))
      IF (.NOT.(DR.LT.1.D0)) GO TO 10036
      DCOSA=(DR*DR*DSALT+DSSMO*SQRT(1.D0-DR*DR))/
     +                             (DR*DR+DSSMO)
      GO TO 10037
10036 CONTINUE
      DS=2.D0-DR
      DCOSA=(DS*DS*DSALT-DSSMO*SQRT(1.D0-DS*DS))/
     +                             (DS*DS+DSSMO)
10037 CONTINUE
      DSINA=SQRT(1.D0-DCOSA*DCOSA)
      DSINPH=DSINA*DSINB
      DCOSPH=DCOSA*DCSO-DSINA*DSNO*DCOSB
      DCOSLA=SQRT(DSINPH*DSINPH+DCOSPH*DCOSPH)
      IF (.NOT.(DCOSLA.NE.0.D0)) GO TO 10038
      DSINPH=DSINPH/DCOSLA
      DCOSPH=DCOSPH/DCOSLA
10038 CONTINUE
      IF (.NOT.(ABS(DSNO).GT.1.D-4)) GO TO 10039
      DSINLA=(DCOSA-DCOSLA*DCOSPH*DCSO)/DSNO
      GO TO 10040
10039 CONTINUE
      DSINLA=DSINA*DCOSB
10040 CONTINUE
      RLAT=RTOD*REAL(ATAN2(DSINLA,DCOSLA))
      RLON=PHOC+RTOD*REAL(ATAN2(DSINA*DSINB,
     +                    DCOSA*DCSO-DSINA*DSNO*DCOSB))
      IF (ABS(RLON).GT.180.) RLON=RLON-SIGN(360.,RLON)
      CALL MAPITM (RLAT,RLON,IPEN,
     +             IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',9).NE.0) RETURN
      IPEN=1
      IF (I.EQ.360) IPEN=2
10035 CONTINUE
      L10018=    4
      GO TO 10018
10041 CONTINUE
      IF (DR.EQ.1.0002D0) GO TO 10042
      DR=1.0002D0
      GO TO 10034
10042 CONTINUE
10033 CONTINUE
      SALT=SSLT
      GO TO 107
C
C Note:  The constant "1.999999500000" is the real effective radius of
C the limb of the Lambert equal area projection, as determined by the
C test at statement number 106 in the routine MAPTRN.
C
  103 URAD=1.999999500000
      RVTU=1.
      GO TO 106
C
C Note:  The constant "3.140178439909" is the real effective radius of
C the limb of the azimuthal equidistant projection, as determined by the
C test at statement number 108 in the routine MAPTRN.
C
  104 URAD=3.140178439909
      RVTU=1.
      GO TO 106
C
  105 URAD=2.
      RVTU=0.5
C
  106 IF (ELPF.AND.ABS(UCEN).LT.1.E-4.AND.
     +             ABS(VCEN).LT.1.E-4.AND.
     +             ABS(URNG-URAD).LT.1.E-4.AND.
     +             ABS(VRNG/URNG-RVTU).LT.1.E-4) GO TO 107
C
      TEMP=.9998
C
10043 CONTINUE
      IVIS=-1
      I = 1
      GO TO 10046
10044 CONTINUE
      I =I +1
10046 CONTINUE
      IF (I .GT.(361)) GO TO 10045
      UCIR=TEMP*URAD*COS(DTOR*REAL(I-1))
      VCIR=TEMP*URAD*SIN(DTOR*REAL(I-1))
      U=UCIR
      V=RVTU*VCIR
      IF (.NOT.(.NOT.ELPF.AND.(U.LT.UMIN.OR.U.GT.UMAX.OR.V.LT.VMIN.OR.V.
     +GT.VMAX))) GO TO 10047
      IF (.NOT.(IVIS.EQ.1)) GO TO 10048
      CALL MAPTRP (UOLD,VOLD,U,V,UEDG,VEDG)
      XCRD=UEDG
      YCRD=VEDG
      L10009=    6
      GO TO 10009
10049 CONTINUE
10048 CONTINUE
      IVIS=0
      GO TO 10050
10047 CONTINUE
      IF (.NOT.(ELPF.AND.(((U-UCEN)/URNG)**2+((V-VCEN)/VRNG)**2.GT.1.)))
     +GO TO 10051
      IF (.NOT.(IVIS.EQ.1)) GO TO 10052
      CALL MAPTRE (UOLD,VOLD,U,V,UEDG,VEDG)
      XCRD=UEDG
      YCRD=VEDG
      L10009=    7
      GO TO 10009
10053 CONTINUE
10052 CONTINUE
      IVIS=0
      GO TO 10050
10051 CONTINUE
      IF (.NOT.(IVIS.LT.0)) GO TO 10054
      XCRD=U
      YCRD=V
      L10004=    3
      GO TO 10004
10055 CONTINUE
      IVIS=1
      GO TO 10056
10054 CONTINUE
      IF (.NOT.(IVIS.EQ.0)) GO TO 10057
      IF (.NOT.ELPF) CALL MAPTRP (U,V,UOLD,VOLD,UOLD,VOLD)
      IF (     ELPF) CALL MAPTRE (U,V,UOLD,VOLD,UOLD,VOLD)
      XCRD=UOLD
      YCRD=VOLD
      L10004=    4
      GO TO 10004
10058 CONTINUE
      IVIS=1
10057 CONTINUE
      XCRD=U
      YCRD=V
      L10009=    8
      GO TO 10009
10059 CONTINUE
10056 CONTINUE
10050 CONTINUE
      UOLD=U
      VOLD=V
      GO TO 10044
10045 CONTINUE
      L10018=    5
      GO TO 10018
10060 CONTINUE
      IF (TEMP.EQ.1.0002) GO TO 10061
      TEMP=1.0002
      GO TO 10043
10061 CONTINUE
C
C Restore the color index and dash pattern.
C
  107 CALL MAPCHM (-4,0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',10).NE.0) RETURN
C
C If the selected outline type is "NONE", quit; no outlines need to
C be drawn.
C
      IF (NOUT.LE.0) RETURN
C
C Set the flag IWGF to say whether or not the whole globe is shown by
C the current projection.  If so (IWGF=1), there's no need to waste the
C time required to check each outline point group for intersection with
C the window.
C
      IWGF=0
      IF (BLAM-SLAM.GT.179.9999.AND.BLOM-SLOM.GT.359.9999) IWGF=1
C
C IGIS keeps track of changes in the group identifier, so that the
C color index can be changed when necessary.
C
      IGIS=0
C
C Position to the user-selected portion of the outline dataset.
C
      CALL MAPIO (1)
      IF (ICFELL('MAPBLM',11).NE.0) RETURN
      NSEG=0
C
C Read the next record (group of points).
C
  301 CALL MAPIO (2)
      IF (ICFELL('MAPBLM',12).NE.0) RETURN
      NSEG=NSEG+1
C
C Check for the end of the desired data.
C
      IF (NPTS.EQ.0) GO TO 303
C
C If less than the whole globe is shown by the projection, do a quick
C check for intersection of the box surrounding the point group with
C the area shown.
C
      IF (.NOT.(IWGF.EQ.0)) GO TO 10062
      IF (SLAG.GT.BLAM.OR.BLAG.LT.SLAM) GO TO 301
      IF ((SLOG     .GT.BLOM.OR.BLOG     .LT.SLOM).AND.
     +    (SLOG-360..GT.BLOM.OR.BLOG-360..LT.SLOM).AND.
     +    (SLOG+360..GT.BLOM.OR.BLOG+360..LT.SLOM)) GO TO 301
10062 CONTINUE
C
C See if the user wants to omit this point group.
C
      CALL HLUMAPEOD (NOUT,NSEG,IDOS(NOUT)+IDLS,
     +                          IDOS(NOUT)+IDRS,NPTS,PNTS)
      IF (ICFELL('MAPBLM',13).NE.0) RETURN
      IF (NPTS.LE.1) GO TO 301
C
C If we've switched to a new group, set the color index, dotting, and
C dash pattern for the group.
C
      IF (.NOT.(IGID.NE.IGIS)) GO TO 10063
      IF (.NOT.(IGIS.NE.0)) GO TO 10064
      CALL MAPCHM (-4-IGIS,0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',14).NE.0) RETURN
10064 CONTINUE
      CALL MAPCHM (4+IGID,IOR(ISHIFT(32767,1),1),
     +                              IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',15).NE.0) RETURN
      IGIS=IGID
10063 CONTINUE
C
C Plot the group.
C
      CALL MAPITM (PNTS(1),PNTS(2),0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',16).NE.0) RETURN
C
      DO 10065 K=2,NPTS-1
      CALL MAPITM (PNTS(2*K-1),PNTS(2*K),1,
     +             IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',17).NE.0) RETURN
10065 CONTINUE
C
      CALL MAPITM (PNTS(2*NPTS-1),PNTS(2*NPTS),2,
     +             IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',18).NE.0) RETURN
C
C Force a buffer dump.
C
      L10018=    6
      GO TO 10018
10066 CONTINUE
C
C Go get another group.
C
      GO TO 301
C
C Reset the color index, dotting, and dash pattern, if necessary.
C
  303 CONTINUE
      IF (.NOT.(IGIS.NE.0)) GO TO 10067
      CALL MAPCHM (-4-IGIS,0,IAM,XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',19).NE.0) RETURN
10067 CONTINUE
C
C Done.
C
      RETURN
C
C The following internal procedure is invoked to start a line.
C
10004 CONTINUE
      IF (.NOT.(NCRA.GT.1)) GO TO 10068
      CALL ARDRLN (IAM,XCRA,YCRA,NCRA,
     +             XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',20).NE.0) RETURN
10068 CONTINUE
      XCRA(1)=XCRD
      YCRA(1)=YCRD
      NCRA=1
      GO TO (10003,10012,10055,10058) , L10004
C
C The following internal procedure is invoked to continue a line.
C
10009 CONTINUE
      IF (.NOT.(NCRA.EQ.100)) GO TO 10069
      CALL ARDRLN (IAM,XCRA,YCRA,NCRA,
     +             XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',21).NE.0) RETURN
      XCRA(1)=XCRA(100)
      YCRA(1)=YCRA(100)
      NCRA=1
10069 CONTINUE
      NCRA=NCRA+1
      XCRA(NCRA)=XCRD
      YCRA(NCRA)=YCRD
      GO TO (10008,10013,10014,10015,10016,10049,10053,10059) , L10009
C
C The following internal procedure is invoked to terminate a line.
C
10018 CONTINUE
      IF (.NOT.(NCRA.GT.1)) GO TO 10070
      CALL ARDRLN (IAM,XCRA,YCRA,NCRA,
     +             XCS,YCS,MCS,IAI,IAG,MAI,LPR)
      IF (ICFELL('MAPBLM',22).NE.0) RETURN
      NCRA=0
10070 CONTINUE
      GO TO (10017,10021,10031,10041,10060,10066) , L10018
C
      END
