C     
C      $Id: xy03f.f,v 1.11 1995-04-06 14:43:31 haley Exp $
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                      C
C                Copyright (C)  1995                                   C
C        University Corporation for Atmospheric Research               C
C                All Rights Reserved                                   C
C                                                                      C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C  File:       xy03f.f
C
C  Author:     Mary Haley
C          National Center for Atmospheric Research
C          PO 3000, Boulder, Colorado
C
C  Date:       Wed Feb  8 11:44:39 MST 1995
C
C  Description:    This program shows how to create an XyPlot object
C                  with some of the XyPlot line resources tweaked.  A
C                  resource file is used to changed the resources. 
C                  This program uses the same Y-axis dataset as the
C                  example "xy02", but this time values for the X
C                  axis are specified, changing the look of the plot.
C 
C                  The "CoordArrays" object is used to set up the data.
C
      external NhlFAppLayerClass
      external NhlFXWorkstationLayerClass
      external NhlFNcgmWorkstationLayerClass
      external NhlFXyPlotLayerClass
      external NhlFCoordArraysLayerClass
C
C Define the number of points in the curve.
C
      parameter(NPTS=500)
      parameter(PI100=.031415926535898)

      integer appid,xworkid,plotid,dataid
      integer rlist, i
      real xdra(NPTS), ydra(NPTS), theta
      integer NCGM
C
C Default is to an X workstation.
C
      NCGM=0
C
C Initialize some data for the XyPlot object.
C
      do 10 i = 1,NPTS
         theta = PI100*real(i-1)
         xdra(i) = 500.+.9*real(i-1)*cos(theta)
         ydra(i) = 500.+.9*real(i-1)*sin(theta)
 10   continue
C
C Initialize the HLU library and set up resource template.
C
      call NhlFInitialize
      call NhlFRLCreate(rlist,'setrl')
C
C Create Application object.  The Application object name is used to
C determine the name of the resource file, which is "xy03.res" in
C this case.
C
      call NhlFRLClear(rlist)
      call NhlFRLSetString(rlist,'appDefaultParent','True',ierr)
      call NhlFRLSetString(rlist,'appUsrDir','./',ierr)
      call NhlFCreate(appid,'xy03',NhlFAppLayerClass,0,rlist,ierr)

      if (NCGM.eq.1) then
C
C Create an NCGM workstation.
C
         call NhlFRLClear(rlist)
         call NhlFRLSetString(rlist,'wkMetaName','./xy03f.ncgm',ierr)
         call NhlFCreate(xworkid,'xy03Work',
     +        NhlFNcgmWorkstationLayerClass,0,rlist,ierr)
      else
C
C Create an xworkstation object.
C
         call NhlFRLClear(rlist)
         call NhlFRLSetString(rlist,'wkPause','True',ierr)
         call NhlFCreate(xworkid,'xy03Work',NhlFXWorkstationLayerClass,
     +        0,rlist,ierr)
      endif
C
C Define the data object.  The id for this object will later be used
C as the value for the XyPlot data resource, 'xyCoordData'.
C
      call NhlFRLClear(rlist)
      call NhlFRLSetFloatArray(rlist,'caXArray',xdra,NPTS,ierr)
      call NhlFRLSetFloatArray(rlist,'caYArray',ydra,NPTS,ierr)
      call NhlFCreate(dataid,'xyData',NhlFCoordArraysLayerClass,
     +                0,rlist,ierr)
C
C Create the XyPlot object which is created as a child of the
C Xworkstation object.  The resources that are being changed are done
C in the "xy03.res" file.
C
      call NhlFRLClear(rlist)
      call NhlFRLSetInteger(rlist,'xyCoordData',dataid,ierr)
      call NhlFCreate(plotid,'xyPlot',NhlFXyPlotLayerClass,xworkid,
     +                rlist,ierr)
C
C Draw the plot.
C
      call NhlFDraw(plotid,ierr)
      call NhlFFrame(xworkid,ierr)
C
C NhlDestroy destroys the given id and all of its children
C so destroying "xworkid" will also destroy "plotid".
C
      call NhlFRLDestroy(rlist)
      call NhlFDestroy(xworkid,ierr)
      call NhlFDestroy(appid,ierr)
C
C Restores state.
C
      call NhlFClose
      stop
      end

