C
C $Id: mapdrw.f,v 1.4 1993-12-21 00:32:37 kennison Exp $
C
      SUBROUTINE MAPDRW
C
C Declare required common blocks.  See MAPBD for descriptions of these
C common blocks and the variables in them.
C
      COMMON /MAPCM4/ INTF,JPRJ,PHIA,PHIO,ROTA,ILTS,PLA1,PLA2,PLA3,PLA4,
     +                PLB1,PLB2,PLB3,PLB4,PLTR,GRID,IDSH,IDOT,LBLF,PRMF,
     +                ELPF,XLOW,XROW,YBOW,YTOW,IDTL,GRDR,SRCH,ILCW
      LOGICAL         INTF,LBLF,PRMF,ELPF
      SAVE /MAPCM4/
C
C Initialize the package, draw and label the grid, and draw outlines.
C
      IF (INTF) THEN
        CALL MAPINT
        IF (ICFELL('MAPDRW',1).NE.0) RETURN
      END IF
      CALL MAPGRD
      IF (ICFELL('MAPDRW',2).NE.0) RETURN
      CALL MAPLBL
      IF (ICFELL('MAPDRW',3).NE.0) RETURN
      CALL MAPLOT
      IF (ICFELL('MAPDRW',4).NE.0) RETURN
C
      RETURN
      END
