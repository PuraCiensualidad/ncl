      PROGRAM CCPCLU
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
      
      CALL CPSETI('CLS - CONTOUR LEVEL SELECTION FLAG',0)
      CALL CPSETI('NCL - NUMBER OF CONTOUR LEVELS',40)
      DO 11 I=1,40
         CALL CPSETI ('PAI - PARAMETER ARRAY INDEX',I)
         CALL CPSETR ('CLV - CONTOUR LEVEL VALUES',5.0*REAL(I)-15.)
         CALL CPSETI ('CLU - CONTOUR LEVEL USE FLAG',MOD(I,4))
 11   CONTINUE
C
C Call conpack normally
C
      CALL CPRECT(Z,K,M,N,RWRK,LRWK,IWRK,LIWK)
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
