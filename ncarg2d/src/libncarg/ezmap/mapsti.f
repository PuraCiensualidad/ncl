C
C $Id: mapsti.f,v 1.6 1994-03-18 23:50:39 kennison Exp $
C
      SUBROUTINE MAPSTI (WHCH,IVAL)
C
      CHARACTER*(*) WHCH
C
C Declare required common blocks.  See MAPBD for descriptions of these
C common blocks and the variables in them.
C
      COMMON /MAPCM2/ UMIN,UMAX,VMIN,VMAX,UEPS,VEPS,UCEN,VCEN,URNG,VRNG,
     +                BLAM,SLAM,BLOM,SLOM,ISSL
      SAVE /MAPCM2/
      COMMON /MAPCM4/ INTF,JPRJ,PHIA,PHIO,ROTA,ILTS,PLA1,PLA2,PLA3,PLA4,
     +                PLB1,PLB2,PLB3,PLB4,PLTR,GRID,IDSH,IDOT,LBLF,PRMF,
     +                ELPF,XLOW,XROW,YBOW,YTOW,IDTL,GRDR,SRCH,ILCW
      LOGICAL         INTF,LBLF,PRMF,ELPF
      SAVE /MAPCM4/
      COMMON /MAPCM7/ ULOW,UROW,VBOW,VTOW
      SAVE /MAPCM7/
      COMMON /MAPCMA/ DPLT,DDTS,DSCA,DPSQ,DSSQ,DBTD,DATL
      SAVE /MAPCMA/
      COMMON /MAPCMB/ IIER
      SAVE /MAPCMB/
      COMMON /MAPCMC/ IGI1,IGI2,NOVS,XCRA(100),YCRA(100),NCRA
      SAVE /MAPCMC/
      COMMON /MAPCMQ/ ICIN(7)
      SAVE /MAPCMQ/
      COMMON /MAPSAT/ SALT,SSMO,SRSS,ALFA,BETA,RSNA,RCSA,RSNB,RCSB
      SAVE /MAPSAT/
      COMMON /MAPDPS/ DSNA,DCSA,DSNB,DCSB
      DOUBLE PRECISION DSNA,DCSA,DSNB,DCSB
      SAVE /MAPDPS/
C
      IF (ICFELL('MAPSTI - UNCLEARED PRIOR ERROR',1).NE.0) THEN
        IIER=-1
        RETURN
      END IF
      IF      (WHCH(1:2).EQ.'C1'.OR.WHCH(1:2).EQ.'c1') THEN
        ICIN(1)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C2'.OR.WHCH(1:2).EQ.'c2') THEN
        ICIN(2)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C3'.OR.WHCH(1:2).EQ.'c3') THEN
        ICIN(3)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C4'.OR.WHCH(1:2).EQ.'c4') THEN
        ICIN(4)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C5'.OR.WHCH(1:2).EQ.'c5') THEN
        ICIN(5)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C6'.OR.WHCH(1:2).EQ.'c6') THEN
        ICIN(6)=IVAL
      ELSE IF (WHCH(1:2).EQ.'C7'.OR.WHCH(1:2).EQ.'c7') THEN
        ICIN(7)=IVAL
      ELSE IF (WHCH(1:2).EQ.'DA'.OR.WHCH(1:2).EQ.'da') THEN
        IDSH=IVAL
      ELSE IF (WHCH(1:2).EQ.'DD'.OR.WHCH(1:2).EQ.'dd') THEN
        DDTS=IVAL
        DBTD=DDTS/DSCA
      ELSE IF (WHCH(1:2).EQ.'DL'.OR.WHCH(1:2).EQ.'dl') THEN
        IDTL=IVAL
      ELSE IF (WHCH(1:2).EQ.'DO'.OR.WHCH(1:2).EQ.'do') THEN
        IDOT=IVAL
      ELSE IF (WHCH(1:2).EQ.'EL'.OR.WHCH(1:2).EQ.'el') THEN
        ELPF=IVAL.NE.0
      ELSE IF (WHCH(1:2).EQ.'GR'.OR.WHCH(1:2).EQ.'gr') THEN
        GRID=IVAL
      ELSE IF (WHCH(1:2).EQ.'G1'.OR.WHCH(1:2).EQ.'g1') THEN
        IGI1=IVAL
      ELSE IF (WHCH(1:2).EQ.'G2'.OR.WHCH(1:2).EQ.'g2') THEN
        IGI2=IVAL
      ELSE IF (WHCH(1:2).EQ.'LA'.OR.WHCH(1:2).EQ.'la') THEN
        LBLF=IVAL.NE.0
      ELSE IF (WHCH(1:2).EQ.'LS'.OR.WHCH(1:2).EQ.'ls') THEN
        ILCW=IVAL
      ELSE IF (WHCH(1:2).EQ.'MV'.OR.WHCH(1:2).EQ.'mv') THEN
        DPLT=IVAL
        DPSQ=DPLT*DPLT
      ELSE IF (WHCH(1:2).EQ.'PE'.OR.WHCH(1:2).EQ.'pe') THEN
        PRMF=IVAL.NE.0
      ELSE IF (WHCH(1:2).EQ.'RE'.OR.WHCH(1:2).EQ.'re') THEN
        PLTR=IVAL
        DSCA=(UROW-ULOW)*PLTR/(UMAX-UMIN)
        DSSQ=DSCA*DSCA
        DBTD=DDTS/DSCA
      ELSE IF (WHCH(1:2).EQ.'SA'.OR.WHCH(1:2).EQ.'sa') THEN
        SALT=IVAL
        IF (ABS(SALT).GT.1.) THEN
          SSMO=SALT*SALT-1.
          SRSS=SQRT(SSMO)
        END IF
      ELSE IF (WHCH(1:2).EQ.'S1'.OR.WHCH(1:2).EQ.'s1') THEN
        ALFA=ABS(IVAL)
        DSNA=SIN(DBLE(.017453292519943*ALFA))
        RSNA=REAL(DSNA)
        DCSA=COS(DBLE(.017453292519943*ALFA))
        RCSA=REAL(DCSA)
      ELSE IF (WHCH(1:2).EQ.'S2'.OR.WHCH(1:2).EQ.'s2') THEN
        BETA=IVAL
        DSNB=SIN(DBLE(.017453292519943*BETA))
        RSNB=REAL(DSNB)
        DCSB=COS(DBLE(.017453292519943*BETA))
        RCSB=REAL(DCSB)
      ELSE IF (WHCH(1:2).EQ.'VS'.OR.WHCH(1:2).EQ.'vs') THEN
        NOVS=IVAL
      ELSE
        GO TO 901
      END IF
C
C Done.
C
      RETURN
C
C Error exits.
C
  901 IIER=13
      CALL MAPCEM (' MAPSTI - UNKNOWN PARAMETER NAME ',WHCH,IIER,1)
      RETURN
C
      END
