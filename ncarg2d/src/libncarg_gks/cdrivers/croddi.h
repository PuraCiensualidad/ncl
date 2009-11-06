/*
 *      $Id: croddi.h,v 1.3 2009-11-06 18:58:49 fred Exp $
 */
/*
 *      File:           croddi.h
 *
 *      Author:         Fred Clare
 *                      National Center for Atmospheric Research
 *                      PO 3000, Boulder, Colorado
 *
 *      Date:           Fri Mar  7 11:55:16 MST 2008
 *
 *      Description:    This file defines the device dependent structure for
 *                      the gksc.ddp field for the cairo drivers.
 */

#ifndef _croddi_
#define _croddi_

#include "cro.h"
#include "gks.h"
#include "common.h"
#include "transform.h"

typedef struct  CROddi_ {
  int             wks_id;
  int             wks_type;
  Transform2D     transform;
  TransSystem     tsystem;
  CRODeviceSpace  dspace;
  char          *output_file;
  cro_color     color;
  cro_orientation  orientation;
  char          *file_name;
  float         sfill_spacing;
  float         hatch_spacing;
  linejoin_type line_join;
  linecap_type  line_cap;
  float         miter_limit;
  int           stack_size;
  int           path_size;
  float         nominal_width_scale;
  int           full_background;
  float         scaling;
  int           background;
  int           pict_empty;
  int           page_number;
  int           suppress_flag;
  int           max_color; 
  unsigned int  *ctable;
  int           fonts_used[13];
  int           frame_count;
  CROattribute  attributes;
  CoordSpace    gks_clip;
  CROClipRect   cro_clip;
} CROddp;

#endif  /*      _croddi_        */
