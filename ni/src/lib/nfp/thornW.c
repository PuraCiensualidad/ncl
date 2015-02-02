#include <stdio.h>
#include "wrapper.h"

extern void NGCALLF(thorn2,THORN2)(double *, int *, double *, 
                                   double *, double *, int *);

NhlErrorTypes dim_thornthwaite_n_W( void )
{

/*
 * Input variables
 *
 * Argument # 0
 */
  void *temp;
  double *tmp_temp;
  int ndims_temp;
  ng_size_t dsizes_temp[NCL_MAX_DIMENSIONS];
  int has_missing_temp;
  NclScalar missing_temp, missing_flt_temp, missing_dbl_temp;
  NclBasicDataTypes type_temp;

/*
 * Argument # 1
 */
  void *lat;
  double *tmp_lat;
  int ndims_lat;
  ng_size_t dsizes_lat[NCL_MAX_DIMENSIONS];
  NclBasicDataTypes type_lat;

/*
 * Argument # 2
 */
  logical *opt;

/*
 * Return variable
 */
  void *pet;
  double *tmp_pet;
  NclScalar missing_pet;
  NclBasicDataTypes type_pet;

/*
 * Various
 */
  int intim, ret, ier;
  ng_size_t i, j, ntim, nlat, nlon, nlatlon;
  ng_size_t index_temp, index_lat, size_temp;
  char grid_type[13];
/*
 * Retrieve parameters.
 *
 * Note any of the pointer parameters can be set to NULL, which
 * implies you don't care about its value.
 */
/*
 * Get argument # 0
 */
  temp = (void*)NclGetArgValue(
           0,
           3,
           &ndims_temp,
           dsizes_temp,
           &missing_temp,
           &has_missing_temp,
           &type_temp,
           DONT_CARE);

/*
 * Check size of temp.
 */
  ntim = dsizes_temp[0];
  if(ntim > INT_MAX) {
    NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: ntim = %ld is greater than INT_MAX", ntim);
    return(NhlFATAL);
  }
  intim = (int) ntim;

/*
 * Coerce missing value to double if necessary.
 */
  coerce_missing(type_temp,has_missing_temp,&missing_temp,
                 &missing_dbl_temp,&missing_flt_temp);

/*
 * Get argument # 1
 */
  lat = (void*)NclGetArgValue(
           1,
           3,
           &ndims_lat,
           dsizes_lat,
           NULL,
           NULL,
           &type_lat,
           DONT_CARE);

/*
 * Check dimension sizes.
 *
 *   t(ntim)           - lat is a scalar
 *
 *   t(ntim,ncol)      - the grid is unstructured (eg: spectral element), then lat(ncol)
 *
 *   t(ntim,nlat,mlon) - the grid is rectilinear, then lat(nlat)
 *
 *   t(ntim,nlat,mlon) - the grid is curvilinear, then lat(nlat,mlon) 
 */
  if(ndims_temp > 3) {
    NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: temp must be a 1D, 2D, or 3D array");
    return(NhlFATAL);
  }
  if(ndims_temp == 1) {
    if(!is_scalar(ndims_lat,dsizes_lat)) {
      NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: If temp is a 1D array, lat must be a scalar.");
      return(NhlFATAL);
    }
    else {
      strcpy(grid_type,"scalar");
      nlat = nlon = 1;
    }
  }
  if(ndims_temp == 2) {
    if(ndims_lat != 1 || (ndims_lat == 1 && dsizes_lat[0] != dsizes_temp[1])) {
      NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: If temp is a 2D array, then lat must be 1D and the same size as rightmost dimension of temp");
      return(NhlFATAL);
    }
    else {
      strcpy(grid_type,"unstructured");
      nlat = dsizes_lat[0];
      nlon = 1;
    }
  }
  if( (ndims_temp == 3 && (ndims_lat == 1 && dsizes_lat[0] != dsizes_temp[1])) || 
      (ndims_lat == 2 && (dsizes_lat[0] != dsizes_temp[1] || 
                          dsizes_lat[1] != dsizes_temp[2])) ||
      ndims_lat > 2) {
    NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: If temp is a 3D array, then lat must either be a 1D array of size nlat or a 2D array of size nlat x mlon");
    return(NhlFATAL);
  }
  else {
    if(ndims_lat == 1) {
      strcpy(grid_type,"rectilinear");
      nlat = dsizes_lat[0];
      nlon = 1;
    }
    else {
      strcpy(grid_type,"curvilinear");
      nlat = dsizes_lat[0];
      nlon = dsizes_lat[1];
    }
  }

/*
 * Get argument # 2
 */
  opt = (logical*)NclGetArgValue(
           2,
           3,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           DONT_CARE);

/*
 * Calculate temp size (and hence output size).
 */
  size_temp = 1;
  for(i = 0; i < ndims_temp; i++) size_temp *= dsizes_temp[i];
/*
 * Allocate space for coercing input arrays to double
 */
  tmp_temp = (double *)calloc(ntim,sizeof(double));
  if(tmp_temp == NULL) {
    NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: Unable to allocate memory for coercing input array to double");
    return(NhlFATAL);
  }
  if(type_lat != NCL_double) tmp_lat = (double *)calloc(1,sizeof(double));

/* 
 * Allocate space for output array.
 */
  if(type_temp != NCL_double) {
    pet     = (void *)calloc(size_temp, sizeof(float));
    tmp_pet = (double *)calloc(ntim,sizeof(double));
    if(pet == NULL || tmp_pet == NULL) {
      NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: Unable to allocate memory for temporary output array");
      return(NhlFATAL);
    }
    type_pet    = NCL_float;
    missing_pet = missing_flt_temp;
  }
  else {
    pet = (void *)calloc(size_temp, sizeof(double));
    if(pet == NULL) {
      NhlPError(NhlFATAL,NhlEUNKNOWN,"dim_thornthwaite_n: Unable to allocate memory for output array");
      return(NhlFATAL);
    }
    type_pet    = NCL_double;
    missing_pet = missing_dbl_temp;
  }

/*
 * Loop across nlat and nlon and pass in ntim subsections of temp
 * and single latitude values to Fortran routine.
 */
  nlatlon = nlat * nlon;

  for(i = 0; i < nlat; i++) {
/* 
 * A rectilinear grid is a special case as it has
 * lat values for the lat dimension.  Scalar
 * and unstructured grids have nlon=1, and 
 * curvilinear grids have nlat x nlon latitude values
 */
    if(!strcmp(grid_type,"rectilinear")) {
      if(type_lat != NCL_double) {
        coerce_subset_input_double(lat,tmp_lat,i,type_lat,1,0,NULL,NULL);
      }
      else {
        tmp_lat = &((double*)lat)[i];
      }
    }
    for(j = 0; j < nlon; j++) {
      index_temp = i*nlon + j;
/*
 * Coerce subsection of temp (tmp_temp) to double if necessary.
 */
      coerce_subset_input_double_step(temp,tmp_temp,index_temp,nlatlon,type_temp,
                                      ntim,0,NULL,NULL);
/*
 * For anything but a rectilinear grid (which we handled above), 
 * coerce subsection of lat (tmp_lat) to double if necessary.
 */
      if(strcmp(grid_type,"rectilinear")) {
        index_lat = i*nlon+j;
        if(type_lat != NCL_double) {
          coerce_subset_input_double(lat,tmp_lat,index_lat,type_lat,1,0,NULL,NULL);
        }
        else {
          tmp_lat = &((double*)lat)[index_lat];
        }
      }
/*
 * Point temporary output array to void output array if appropriate.
 */
      if(type_pet == NCL_double) tmp_pet = &((double*)pet)[index_temp];
/*
 * Call the Fortran routine.
 */
      NGCALLF(thorn2,THORN2)(tmp_temp, &intim, &missing_dbl_temp.doubleval, tmp_lat, tmp_pet, &ier);
/*
 * Coerce output back to float if necessary.
 */
      if(type_pet == NCL_float) {
        coerce_output_float_only(pet,tmp_pet,ntim,index_temp);
      }
      index_temp += ntim;
    }
  }

/*
 * Free unneeded memory.
 */
  if(type_temp != NCL_double) NclFree(tmp_temp);
  if(type_lat  != NCL_double) NclFree(tmp_lat);
  if(type_pet  != NCL_double) NclFree(tmp_pet);

/*
 * Return value back to NCL script.
 */
  ret = NclReturnValue(pet,ndims_temp,dsizes_temp,&missing_pet,type_pet,0);
  return(ret);
}