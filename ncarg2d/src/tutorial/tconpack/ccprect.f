	PROGRAM CCPREC

C
C Define error file, Fortran unit number, and workstation type,
C and workstation ID.
C
        PARAMETER (IERRF=6, LUNIT=2, IWTYPE=SED_WSTYPE, IWKID=1)

        PARAMETER (M=40,N=40,LRWK=1000,LIWK=1000)
	REAL Z(M,N), RWRK(LRWK)
	INTEGER IWRK(LIWK)

	CALL GETDAT (Z, M, N) 

C Open GKS
        CALL GOPKS (IERRF, ISZDM)
        CALL GOPWK (IWKID, LUNIT, IWTYPE)
        CALL GACWK (IWKID)

C Initialize Conpack
	CALL CPRECT(Z,M,M,N,RWRK,LRWK,IWRK,LIWK)
C Draw perimeter
	CALL CPBACK(Z, RWRK, IWRK)
C Draw Contours
	CALL CPCLDR(Z,RWRK,IWRK)
C Mark data locations
	CALL MARK (M,N)
C Close frame and close GKS
	CALL FRAME
        CALL GDAWK (IWKID)
        CALL GCLWK (IWKID)
        CALL GCLKS

	STOP
	END

	SUBROUTINE GETDAT (Z, M, N)
	INTEGER I,J,M,N
	REAL Z(M,N)

	DO 10, I=1,M
	  DO 20, J=1,N
	    Z(I,J)= 10E-5*(-16.*REAL(I**2*J) +
     +		    34*REAL(I*J**2) - REAL(6*I) + 93.)
  20	  CONTINUE
  10	CONTINUE

	RETURN
	END

	SUBROUTINE MARK (M, N)

	REAL X, Y
	INTEGER I, J

	CALL GSMKSC(.5)
        DO 11 I=1,M
          DO 21 J=1,N
            X = REAL(I)
            Y = REAL(J)
            CALL POINTS (X, Y, 1, -4, 0)
  21      CONTINUE
  11    CONTINUE


	RETURN
	END
