C
C $Id: ctgetc.f,v 1.1 2003-05-28 15:44:29 kennison Exp $
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
      SUBROUTINE CTGETC (WHCH,CVAL)
C
      CHARACTER*(*) WHCH,CVAL
C
C This subroutine is called to retrieve the character value of a
C specified parameter.
C
C WHCH is the name of the parameter whose value is to be retrieved.
C
C CVAL is a character variable in which the desired value is to be
C returned by CTGETC.
C
C
C Declare all of the CONPACKT common blocks.
C
C
C CTCOM1 contains integer and real variables.
C
      COMMON /CTCOM1/ ANCF,ANHL,ANIL,ANLL,CDMX,CHWM,CINS,CINT(10)
      COMMON /CTCOM1/ CINU,CLDB(256),CLDL(256),CLDR(256)
      COMMON /CTCOM1/ CLDT(256),CLEV(256),CLWA(258),CXCF
      COMMON /CTCOM1/ CXIL,CYCF,CYIL,DBLF,DBLM,DBLN,DBLV,DFLD,DMAX
      COMMON /CTCOM1/ DMIN,DOPT,DVAL,EPSI,FNCM,GRAV,GRSD,GSDM,HCHL
      COMMON /CTCOM1/ HCHS,HLSR,IAIA(258),IAIB(256),IBCF,IBHL
      COMMON /CTCOM1/ IBIL,IBLL,ICAF,ICCF,ICCL(258),ICFF,ICHI
      COMMON /CTCOM1/ ICHL,ICIL,ICLL(256),ICLO,ICLP(256),ICLS
      COMMON /CTCOM1/ ICLU(258),ICLV,ICLW,IDUF,IGCL,IGLB,IGRM
      COMMON /CTCOM1/ IGRN,IGVS,IHCF,IHLE,IIWS(2),IIWU,ILBC
      COMMON /CTCOM1/ IMPF,INCX(8),INCY(8),INHL,INIL,INIT,INLL
      COMMON /CTCOM1/ IOCF,IOHL,IOLL,IPAI,IPCF,IPIC,IPIE,IPIL,IPLL
      COMMON /CTCOM1/ IRWS(4),IRWU,ISET,IWSO,JODP,JOMA,JOTZ
      COMMON /CTCOM1/ LCTM,LEA1,LEA2,LEA3,LEE1,LEE2,LEE3,LINS
      COMMON /CTCOM1/ LINT(10),LINU,LIWK,LIWM,LIWS(2),LNLG,LOEN
      COMMON /CTCOM1/ LOPN,LOTN,LRWC,LRWG,LRWK,LRWM,LRWS(4)
      COMMON /CTCOM1/ LSDD,LSDL,LSDM,LTCF,LTHI,LTIL,LTLO,MIRO
      COMMON /CTCOM1/ NCLB(256),NCLV,NDGL,NEDG,NEXL,NEXT,NEXU
      COMMON /CTCOM1/ NLBS,NLSD,NLZF,NOMF,NOVS,NPNT,NR04,NSDL
      COMMON /CTCOM1/ NSDR,NTRI,OORV,PITH,SCFS,SCFU,SEGL,T2DS
      COMMON /CTCOM1/ UCMN,UCMX,UVPB,UVPL,UVPR,UVPS,UVPT,UWDB,UWDL
      COMMON /CTCOM1/ UWDR,UWDT,WCCF,WCHL,WCIL,WCLL,WLCF,WLHL,WLIL
      COMMON /CTCOM1/ WLLL,WOCH,WODA,WTCD,WTGR,WTNC,WTOD,WWCF,WWHL
      COMMON /CTCOM1/ WWIL,WWLL,XLBC,XMAX,XMIN,XVPL,XVPR,XWDL,XWDR
      COMMON /CTCOM1/ YLBC,YMAX,YMIN,YVPB,YVPT,YWDB,YWDT,ZMAX,ZMIN
C
      EQUIVALENCE (IIWS(1),II01),(LIWS(1),LI01)
      EQUIVALENCE (IIWS(2),II02),(LIWS(2),LI02)
      EQUIVALENCE (IRWS(1),IR01),(LRWS(1),LR01)
      EQUIVALENCE (IRWS(2),IR02),(LRWS(2),LR02)
      EQUIVALENCE (IRWS(3),IR03),(LRWS(3),LR03)
      EQUIVALENCE (IRWS(4),IR04),(LRWS(4),LR04)
      SAVE   /CTCOM1/
C
C CTCOM2 holds character parameters.
C
      COMMON /CTCOM2/ CHEX,CLBL(256),CLDP(258),CTMA,CTMB,FRMT
      COMMON /CTCOM2/ TXCF,TXHI,TXIL,TXLO
      CHARACTER*13 CHEX
      CHARACTER*64 CLBL
      CHARACTER*128 CLDP
      CHARACTER*500 CTMA,CTMB
      CHARACTER*8 FRMT
      CHARACTER*64 TXCF
      CHARACTER*32 TXHI
      CHARACTER*128 TXIL
      CHARACTER*32 TXLO
      SAVE   /CTCOM2/
C
C Check for an uncleared prior error.
C
      IF (ICFELL('CTGETC - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
C
C Check for a parameter name that is too short.
C
      IF (LEN(WHCH).LT.3) THEN
        CTMB(1:36)='CTGETC - PARAMETER NAME TOO SHORT - '
        CTMB(37:36+LEN(WHCH))=WHCH
        CALL SETER (CTMB(1:36+LEN(WHCH)),2,1)
        RETURN
      END IF
C
C Check for incorrect use of the index parameter.
C
      IF (WHCH(1:3).EQ.'CLD'.OR.WHCH(1:3).EQ.'cld') THEN
        IF (IPAI.GE.1.AND.IPAI.LE.NCLV) THEN
          JPAI=IPAI
        ELSE IF (IPAI.LE.-1.AND.IPAI.GE.-3) THEN
          JPAI=256+ABS(IPAI)
        ELSE
          GO TO 10002
        END IF
      ELSE IF (WHCH(1:3).EQ.'LLT'.OR.WHCH(1:3).EQ.'llt') THEN
        IF (IPAI.LT.1.OR.IPAI.GT.NCLV) THEN
          GO TO 10002
        END IF
      END IF
C
      GO TO 10004
10002 CONTINUE
        CTMB(1:36)='CTGETC - GETTING XXX - PAI INCORRECT'
        CTMB(18:20)=WHCH(1:3)
        CALL SETER (CTMB(1:36),3,1)
        RETURN
10004 CONTINUE
C
C Get the appropriate parameter value.
C
      IF (WHCH(1:3).EQ.'CFT'.OR.WHCH(1:3).EQ.'cft') THEN
        CVAL=TXCF(1:LTCF)
      ELSE IF (WHCH(1:3).EQ.'CLD'.OR.WHCH(1:3).EQ.'cld') THEN
        CVAL=CLDP(JPAI)
      ELSE IF (WHCH(1:3).EQ.'CTM'.OR.WHCH(1:3).EQ.'ctm') THEN
        CVAL=CTMA(1:LCTM)
      ELSE IF (WHCH(1:3).EQ.'DVA'.OR.WHCH(1:3).EQ.'dva') THEN
        CALL CTSBST ('$DVA$',CVAL,LCVL)
      ELSE IF (WHCH(1:3).EQ.'DVU'.OR.WHCH(1:3).EQ.'dvu') THEN
        CALL CTSBST ('$DVAU$',CVAL,LCVL)
      ELSE IF (WHCH(1:3).EQ.'HIT'.OR.WHCH(1:3).EQ.'hit') THEN
        CVAL=TXHI(1:LTHI)
      ELSE IF (WHCH(1:3).EQ.'HLT'.OR.WHCH(1:3).EQ.'hlt') THEN
        IF (TXHI(1:LTHI).EQ.TXLO(1:LTLO)) THEN
          CVAL=TXHI
        ELSE
          CVAL=TXHI(1:LTHI)//''''//TXLO(1:LTLO)
        END IF
      ELSE IF (WHCH(1:3).EQ.'ILT'.OR.WHCH(1:3).EQ.'ilt') THEN
        CVAL=TXIL(1:LTIL)
      ELSE IF (WHCH(1:3).EQ.'LLT'.OR.WHCH(1:3).EQ.'llt') THEN
        CVAL=CLBL(IPAI)
      ELSE IF (WHCH(1:3).EQ.'LOT'.OR.WHCH(1:3).EQ.'lot') THEN
        CVAL=TXLO(1:LTLO)
      ELSE
        CTMB(1:36)='CTGETC - PARAMETER NAME NOT KNOWN - '
        CTMB(37:39)=WHCH(1:3)
        CALL SETER (CTMB(1:39),4,1)
        RETURN
      END IF
C
C Done.
C
      RETURN
C
      END
