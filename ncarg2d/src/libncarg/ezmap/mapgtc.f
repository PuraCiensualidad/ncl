C
C $Id: mapgtc.f,v 1.6 1994-03-18 23:50:02 kennison Exp $
C
      SUBROUTINE MAPGTC (WHCH,CVAL)
C
      CHARACTER*(*) WHCH,CVAL
C
C Declare required common blocks.  See MAPBD for descriptions of these
C common blocks and the variables in them.
C
      COMMON /MAPCM3/ ITPN,NOUT,NPTS,IGID,IDLS,IDRS,BLAG,SLAG,BLOG,SLOG,
     +                PNTS(200),IDOS(4)
      SAVE /MAPCM3/
      COMMON /MAPCM4/ INTF,JPRJ,PHIA,PHIO,ROTA,ILTS,PLA1,PLA2,PLA3,PLA4,
     +                PLB1,PLB2,PLB3,PLB4,PLTR,GRID,IDSH,IDOT,LBLF,PRMF,
     +                ELPF,XLOW,XROW,YBOW,YTOW,IDTL,GRDR,SRCH,ILCW
      LOGICAL         INTF,LBLF,PRMF,ELPF
      SAVE /MAPCM4/
      COMMON /MAPCM5/ DDCT(5),DDCL(5),LDCT(5),LDCL(5),PDCT(10),PDCL(10)
      CHARACTER*2     DDCT,DDCL,LDCT,LDCL,PDCT,PDCL
      SAVE /MAPCM5/
      COMMON /MAPCMB/ IIER
      SAVE /MAPCMB/
      COMMON /MAPSAT/ SALT,SSMO,SRSS,ALFA,BETA,RSNA,RCSA,RSNB,RCSB
      SAVE /MAPSAT/
      COMMON /MAPDPS/ DSNA,DCSA,DSNB,DCSB
      DOUBLE PRECISION DSNA,DCSA,DSNB,DCSB
      SAVE /MAPDPS/
C
      IF (ICFELL('MAPGTC - UNCLEARED PRIOR ERROR',1).NE.0) THEN
        IIER=-1
        RETURN
      END IF
      IF (     WHCH(1:2).EQ.'AR') THEN
        CVAL=LDCT(ILTS)
      ELSE IF (WHCH(1:2).EQ.'OU') THEN
        CVAL=DDCT(NOUT+1)
      ELSE IF (WHCH(1:2).EQ.'PR') THEN
        CVAL=PDCT(JPRJ)
        IF (JPRJ.EQ.3.AND.ABS(SALT).GT.1.) CVAL=PDCT(10)
      ELSE IF (WHCH(1:2).EQ.'ar') THEN
        CVAL=LDCL(ILTS)
      ELSE IF (WHCH(1:2).EQ.'ou') THEN
        CVAL=DDCL(NOUT+1)
      ELSE IF (WHCH(1:2).EQ.'pr') THEN
        CVAL=PDCL(JPRJ)
        IF (JPRJ.EQ.3.AND.ABS(SALT).GT.1.) CVAL=PDCL(10)
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
  901 IIER=1
      CALL MAPCEM (' MAPGTC - UNKNOWN PARAMETER NAME ',WHCH,IIER,1)
      CVAL=' '
      RETURN
C
      END
