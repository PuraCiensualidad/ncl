      PROGRAM CCPCLC
C
C  Define error file, Fortran unit number, and workstation type,
C  and workstation ID.
C
      PARAMETER (IERRF=6, LUNIT=2, IWTYPE=SED_WSTYPE, IWKID=1)

      PARAMETER (K=40,N=40,LRWK=1000,LIWK=1000)
      REAL Z(K,N), RWRK(LRWK)
      INTEGER I, M, IWRK(LIWK)
      
      CALL GETDAT (Z, K, M, N) 
C
C  Open GKS, open and activate a workstation.
C
      CALL GOPKS (IERRF, ISZDM)
      CALL GOPWK (IWKID, LUNIT, IWTYPE)
      CALL GACWK (IWKID)
C
C Set up color table
C
      CALL COLOR(IWKID)
C     
C Call conpack normally
C
      CALL CPRECT(Z,K,M,N,RWRK,LRWK,IWRK,LIWK)
      CALL CPPKCL(Z, RWRK, IWRK)
C
C Set line color to red if it's negative, green if it's zero, 
C and blue if it's positive.
C
      CALL CPGETI('NCL - NUMBER OF CONTOUR LEVELS',NCON)
      DO 11, I=1,NCON
         CALL CPSETI('PAI - PARAMETER ARRAY INDEX',I)
         CALL CPGETR('CLV - CONTOUR LEVEL VALUES',CVAL)
         IF (CVAL .LT. 0.0) THEN
            CALL CPSETI('CLC - CONTOUR LINE COLOR INDEX',1)
         ELSE IF (CVAL .EQ. 0.0) THEN
            CALL CPSETI('CLC - CONTOUR LINE COLOR INDEX',2)
         ELSE
            CALL CPSETI('CLC - CONTOUR LINE COLOR INDEX',3)
         ENDIF
 11   CONTINUE
      
      CALL CPBACK(Z, RWRK, IWRK)
      CALL CPCLDR(Z,RWRK,IWRK)
C     
C Close frame
C
      CALL FRAME
C
C Deactivate and close workstation, close GKS.
C
      CALL GDAWK (IWKID)
      CALL GCLWK (IWKID)
      CALL GCLKS
      
      STOP
      END
      
      SUBROUTINE GETDAT (Z, K, M, N)
      INTEGER I,J,K,M,N
      REAL Z(K,N)
      
      M=K
      DO 10, I=1,M
         DO 20, J=1,N
            Z(I,J)= 10.E-5*(-16.*REAL(I**2*J) +
     1           34*REAL(I*J**2) - REAL(6*I) + 93.)
 20      CONTINUE
 10   CONTINUE
      
      RETURN
      END
      
      SUBROUTINE COLOR(IWKID)
      
      CALL GSCR (IWKID,0,1.,1.,1.)
      CALL GSCR (IWKID,1,1.,0.,0.)
      CALL GSCR (IWKID,2,0.,1.,0.)
      CALL GSCR (IWKID,3,0.,0.,1.)
      
      RETURN
      END
