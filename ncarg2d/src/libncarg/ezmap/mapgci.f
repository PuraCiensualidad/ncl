C
C $Id: mapgci.f,v 1.3 1993-12-21 00:32:45 kennison Exp $
C
      SUBROUTINE MAPGCI (ALAT,ALON,BLAT,BLON,NOPI,RLTI,RLNI)
C
        DIMENSION RLTI(*),RLNI(*)
C
C This routine, given the latitudes and longitudes of two points A and
C B on the surface of the globe, interpolates NOPI points along the
C great circle route joining A to B and returns the latitudes and
C longitudes of the interpolated points in the arrays RLTI and RLNI.
C
C Rotations about a given axis are used extensively below.  Assume a
C right-handed system with U, V, and W axes.  Rotating by an angle "a"
C about the U axis maps the point (u,v,w) into the point (u',v',w'),
C where
C
C       u' = u
C       v' = v cos(a) - w sin(a)
C       w' = w cos(a) + v sin(a)
C
C A positive value of "a" represents rotation in the direction from the
C V axis to the W axis.
C
C Similarly, rotating by an angle "a" about the V axis maps the point
C (u,v,w) into the point (u',v',w'), where
C
C       u' = u cos(a) + w sin(a)
C       v' = v
C       w' = w cos(a) - u sin(a)
C
C A positive value of "a" represents rotation in the direction from the
C W axis to the U axis.
C
C Rotating by an angle "a" about the W axis maps the point (u,v,w) into
C the point (u',v',w'), where
C
C       u' = u cos(a) - v sin(a)
C       v' = v cos(a) + u sin(a)
C       w' = w
C
C A positive value of "a" represents rotation in the direction from the
C U axis to the V axis.
C
C
C Define the constants used to convert from degrees to radians and
C vice-versa.
C
        DATA DTOR / .017453292519943 /
        DATA RTOD / 57.2957795130823 /
C
C Compute the U, V, and W coordinates (on a unit sphere) of the points
C A and B.
C
        CALT=COS(ALAT*DTOR)
        SALT=SIN(ALAT*DTOR)
        CALN=COS(ALON*DTOR)
        SALN=SIN(ALON*DTOR)
C
        CBLT=COS(BLAT*DTOR)
        SBLT=SIN(BLAT*DTOR)
        CBLN=COS(BLON*DTOR)
        SBLN=SIN(BLON*DTOR)
C
        UCPA=CALT*CALN
        VCPA=CALT*SALN
        WCPA=SALT
C
        UCPB=CBLT*CBLN
        VCPB=CBLT*SBLN
        WCPB=SBLT
C
C Rotating the points about the W axis by the angle -ALON carries point
C A into point C, in the UW plane.  It carries point B into point D.
C
C       CDLN=COS((BLON-ALON)*DTOR)
C       SDLN=SIN((BLON-ALON)*DTOR)
C
C       UCPC=CALT
C       VCPC=0.
C       WCPC=SALT
C
        UCPD=UCPB*CALN+VCPB*SALN
        VCPD=VCPB*CALN-UCPB*SALN
        WCPD=WCPB
C
C       UCPD=CBLT*CDLN
C       VCPD=CBLT*SDLN
C       WCPD=SBLT
C
C Rotating the points about the V axis by the angle ALAT carries point
C C into point E, on the U axis.  It carries point D into point F.
C
C       UCPE=1.
C       VCPE=0.
C       WCPE=0.
C
        UCPF=UCPD*CALT+WCPD*SALT
        VCPF=VCPD
        WCPF=WCPD*CALT-UCPD*SALT
C
C       UCPF=CALT*CBLT*CDLN-SALT*SBLT
C       VCPF=CBLT*SDLN
C       WCPF=CALT*SBLT+SALT*CBLT*CDLN
C
C Rotating the points about the U axis by the angle -ATAN(WCPF/VCPF)
C leaves the position of point E unchanged, but carries point F into
C point G, in the UV plane.
C
        IF (WCPF.NE.0..OR.VCPF.NE.0.) THEN
          ALPH=ATAN2(WCPF,VCPF)
        ELSE
          ALPH=0.
        END IF
C
        CALP=COS(ALPH)
        SALP=SIN(ALPH)
C
        UCPG=UCPF
        VCPG=VCPF*CALP+WCPF*SALP
        WCPG=WCPF*CALP-VCPF*SALP
C
C       UCPG=CALT*CBLT*CDLN-SALT*SBLT
C       VCPG=CBLT*SDLN*CALP-CALT*SBLT*SALP-SALT*CBLT*CDLN*SALP
C       WCPG=CALT*SBLT*CALP+SALT*CBLT*CDLN*CALP+CBLT*SDLN*SALP
C
C The angle from E to G (which is the same as the angle from A to B)
C may now be computed easily.
C
        IF (VCPG.NE.0..OR.UCPG.NE.0.) THEN
          BETA=ATAN2(VCPG,UCPG)
        ELSE
          BETA=0.
        END IF
C
C Interpolate points between the points E and G and map them back to
C the great circle route between A and B.
C
        DO 101 IOPI=1,NOPI
          GAMA=(REAL(IOPI)/REAL(NOPI+1))*BETA
          UCPH=COS(GAMA)
          VCPH=SIN(GAMA)
          WCPH=0.
          UCPO=UCPH
          VCPO=VCPH*CALP-WCPH*SALP
          WCPO=WCPH*CALP+VCPH*SALP
          UCPP=UCPO*CALT-WCPO*SALT
          VCPP=VCPO
          WCPP=WCPO*CALT+UCPO*SALT
          UCPQ=UCPP*CALN-VCPP*SALN
          VCPQ=VCPP*CALN+UCPP*SALN
          WCPQ=WCPP
          RLTI(IOPI)=RTOD*ATAN2(WCPQ,SQRT(UCPQ*UCPQ+VCPQ*VCPQ))
          IF (VCPQ.NE.0..OR.UCPQ.NE.0.) THEN
            RLNI(IOPI)=RTOD*ATAN2(VCPQ,UCPQ)
          ELSE
            RLNI(IOPI)=0.
          END IF
  101   CONTINUE
C
C Done.
C
        RETURN
C
      END
