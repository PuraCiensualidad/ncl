C
C $Id: mpsetl.f,v 1.3 1993-12-21 00:34:13 kennison Exp $
C
      SUBROUTINE MPSETL (WHCH,LVAL)
      CHARACTER*(*) WHCH
      LOGICAL LVAL
      CALL MAPSTL (WHCH,LVAL)
      IF (ICFELL('MPSETL',1).NE.0) RETURN
      RETURN
      END
