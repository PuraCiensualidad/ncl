C
C	$Id: mapdrw.f,v 1.3 1992-09-04 20:38:12 ncargd Exp $
C
C***********************************************************************
C P A C K A G E   E Z M A P   -   I N T R O D U C T I O N
C***********************************************************************
C
C This file contains implementation instructions and the code for the
C package EZMAP.  Banners like the one above delimit the major sections
C of the file.  The code itself is separated into three sections: user-
C level routines, internal routines, and the block data routine which
C determines the default values of internal parameters.  Within each
C section, routines appear in alphabetical order.
C
C***********************************************************************
C P A C K A G E   E Z M A P   -   I M P L E M E N T A T I O N
C***********************************************************************
C
C The EZMAP package is written in FORTRAN-77 and should be relatively
C easy to implement.  The outline data required may be generated by
C running the program
C
C     PROGRAM CONVRT
C       DIMENSION FLIM(4),PNTS(200)
C       REWIND 1
C       REWIND 2
C   1   READ (1,3,END=2) NPTS,IGID,IDLS,IDRS,(FLIM(I),I=1,4)
C       IF (NPTS.GT.1) READ (1,4,END=2) (PNTS(I),I=1,NPTS)
C       WRITE (2) NPTS,IGID,IDLS,IDRS,(FLIM(I),I=1,4),(PNTS(I),I=1,NPTS)
C       GO TO 1
C   2   STOP
C   3   FORMAT (4I4,4F8.3)
C   4   FORMAT (10F8.3)
C     END
C
C with the EZMAP card-image dataset on unit 1.  The output file, on unit
C 2, contains the binary outline data to be used by EZMAP.  The EZMAP
C routine MAPIO (which see) must then be modified to access this file.
C
C***********************************************************************
C T H E   C O D E   -   U S E R - L E V E L   R O U T I N E S
C***********************************************************************
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
      IF (INTF) CALL MAPINT
      CALL MAPGRD
      CALL MAPLBL
      CALL MAPLOT
C
      RETURN
      END
