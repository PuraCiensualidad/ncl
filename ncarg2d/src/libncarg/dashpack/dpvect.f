C
C $Id: dpvect.f,v 1.3 1994-09-22 22:06:25 kennison Exp $
C
      SUBROUTINE DPVECT (XCPU,YCPU)
C
C Given the user coordinates of the point (XCPU,YCPU), this routine
C generates the appropriate call to continue a curve to that point;
C it is meant to be used in combination with DPFRST and DPLAST.
C
C Declare the real/integer common block.
C
        COMMON /DPCMRI/ ANGF,DBPI,EPSI,IDPI,IDPS,ILTL,INDP,IPCF,ISBF,
     +                  ISCF,LCDP,RLS1,RLS2,RMFS,TENS,WCHR,WGAP,WSLD
        SAVE   /DPCMRI/
C
C Check for an uncleared prior error.
C
        IF (ICFELL('DPVECT - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
C
C Get the fractional-system coordinates of the point.
C
        XCPF=CUFX(XCPU)
        IF (ICFELL('DPVECT',2).NE.0) RETURN
C
        YCPF=CUFY(YCPU)
        IF (ICFELL('DPVECT',3).NE.0) RETURN
C
C Call the appropriate lower-level routine, depending on whether
C smoothing is turned on or not.
C
        IF (TENS.LT.0.) THEN
          CALL DPDRAW (XCPF,YCPF,1)
          IF (ICFELL('DPVECT',4).NE.0) RETURN
        ELSE
          CALL DPSMTH (XCPF,YCPF,1)
          IF (ICFELL('DPVECT',5).NE.0) RETURN
        END IF
C
C Done.
C
        RETURN
C
      END
