#!/bin/bash
#Author: John McCormack
#Date: 01/10/2014
#
################################################################################################
#
# Description:
# - This script will log into the OCLI and send the output of each Directory to flat files in 
# - in a directory named "configuration"
#
# --NOTE - Make sure the Administrator Password is correct in OCLI Session Section
#
# Arguments: 
# - 
# Revision History
# Version 1.0
# - John McCormack
# 
# Version 1.1
# - Michael Myburgh 
# - Added the awk script subdirs.awk to find the continous sub directories
#
## Version 1.2
# - John McCormack
# - Added script to rename any files with blank spaces in name
###############################################################################################
# set -o xtrace # uncomment for debugging



HOST=`hostname`


############### Source FW Profile 
. .profile

############### OCLI Session and cut the OCLI Id to be able to reconnect. 
############### Make sure the Administrator password is correct

ocli() {
$FUSIONWORKS_PROD/bin/ocli -x $SESSION_ID $@
}
trim() {
echo $1
}

CONN="connect Administrator/Openet10"
SESSION_ID=$(trim `$FUSIONWORKS_PROD/bin/ocli -g $CONN | cut -d":" -f2`)



############## Get the list of directories from the Ocli listing


ocli_lst()
{
  local nextlvellist
  local curdir
  local rc
  local level=${2}x

  val=`echo $1 | sed 's/"//g'`
#  echo "dollar1 is '$val'"
  CUR_DIR+=/$val
#  echo "About to do: ocli cd $CUR_DIR"
  ocli cd $CUR_DIR\; ls | awk -f subdirs.awk > $level
  rc=$?
  if [ $rc -eq 1 ]; then
    dn=`dirname "$CUR_DIR"`
    bn=`basename "$CUR_DIR"`
    mkdir -p "$PWD$dn"
    ocli cd $dn\; show $bn > "$PWD$dn/$bn"
    echo `echo $CUR_DIR | sed 's/\///'`

#    leaflist+=" $CUR_DIR"
#    echo "leaflist is now \"$leaflist\""

  else
    while read fn; do

#      echo "Now I'm doing \"ocli_lst $fn\""
      ocli_lst "$fn" $level
    done < $level
  fi

#  echo "About to do dirname on \"$CUR_DIR\""
  CUR_DIR=`dirname "$CUR_DIR" | sed "s/ /\\ /"`
  rm $level
}


#########Directory for each FW Configuration

CUR_DIR=/configuration/$1




########Output the configuration to files 
leaflist=""

lst=`ocli cd $CUR_DIR\; ls | awk -f subdirs.awk`
  echo "result for $CUR_DIR is \"$lst\""

for fn in $lst; do
  ocli_lst $fn
done


#########Rename the output directory 
if [ -d configuration ]
then
        echo "config_${HOST} Folder now created"
	mv configuration config_${HOST}
else
        echo "configuration folder is missing"
fi


######### Rename any files with spaces

declare weirdchars=" &\'"

function normalise_and_rename() {
  declare -a list=("${!1}")
      for fileordir in "${list[@]}";
      do
          newname="${fileordir//[${weirdchars}]/_}"
          [[ ! -a "$newname" ]] && \
            mv "$fileordir" "$newname" || \
                echo "Skipping existing file, $newname."
      done
}

declare -a dirs files

while IFS= read -r -d '' dir; do
    dirs+=("$dir")
done < <(find -type d -print0 | sort -z)

normalise_and_rename dirs[@]

while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find -type f -print0 | sort -z)

normalise_and_rename files[@]


exit 0
