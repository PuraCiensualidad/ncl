C
C $Id: mpgetl.f,v 1.3 1993-12-21 00:34:05 kennison Exp $
C
      SUBROUTINE MPGETL (WHCH,LVAL)
      CHARACTER*(*) WHCH
      LOGICAL LVAL
      CALL MAPGTL (WHCH,LVAL)
      IF (ICFELL('MPGETL',1).NE.0) RETURN
      RETURN
      END
