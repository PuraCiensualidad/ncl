#!/bin/csh -f
#
#   $Id: ncargfile.csh,v 1.2 1993-12-01 17:02:55 haley Exp $
#

set file_dir=`ncargpath SED_DBDIR`
if ($status != 0) then
        exit 1
endif

if (! -d "$file_dir") then
  echo "Example directory <$file_dir> does not exist."
  exit 1
endif

if ($#argv < 1) then
echo "usage: ncargfile [-all] file(s)"
echo ""
echo "See <man ncargfile>"
exit
endif

set file_list=( ezmap_area_ids )

set files

while ($#argv > 0)
    
    switch ($1)

        case "-all":
            shift
            set files=($file_list)
            breaksw

        case "-*":
            echo "$0 : Unknown option <$1>"
            exit 1
            breaksw

        default:
            set files=($files $1)
            shift
            breaksw
    endsw
end

foreach file ($files)

################################################################
#
# Code for handling various files
#
################################################################

  echo ""
  echo "Copying NCAR Graphics File <$file>..."
  echo ""
  cp $file_dir/$file .

end
