C
C $Id: mpgetl.f,v 1.5 1994-03-18 23:51:04 kennison Exp $
C
      SUBROUTINE MPGETL (WHCH,LVAL)
      CHARACTER*(*) WHCH
      LOGICAL LVAL
      COMMON /MAPCMB/ IIER
      SAVE /MAPCMB/
      IF (ICFELL('MPGETL - UNCLEARED PRIOR ERROR',1).NE.0) THEN
        IIER=-1
        RETURN
      END IF
      CALL MAPGTL (WHCH,LVAL)
      IF (ICFELL('MPGETL',2).NE.0) RETURN
      RETURN
      END
