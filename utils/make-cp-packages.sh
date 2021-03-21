#!/bin/bash
shopt -s extglob
# uncomment set and trap to trace execution
set -x
#trap read debug

# Files that have changed in most recent commit
git diff --name-only HEAD HEAD~1
CHANGEDFILES=`git diff --name-only HEAD HEAD~1`
CHANGEDFILESB=`git diff --name-only HEAD HEAD~1|grep -v ".zip"`

BASEDIR=`pwd`
SRCLOC="$BASEDIR/CP_Source"
ZIPLOCATION="$BASEDIR/CP_Packages"
COMMONREADME="$BASEDIR/utils/readme.txt"
COMMONDISCLAIMER="$BASEDIR/utils/disclaimer.txt"
CATEGORIES="Apps Browsers Multimedia Network Office Scripts Server Tools_Drivers Unified_Communications"

for category in $CATEGORIES; do
    cd $SRCLOC/$category;

    #  look at every folder under the category
    for cp in *; do

      echo "in the loop with cp = $cp"
      if [ -d $cp ]; then
        zip_needed=false
        zip_file="$ZIPLOCATION/$category/$cp.zip";

        if [ ! -f  $zip_file ]; then
          echo "at 1"
          zip_needed=true;
        fi

        #  if the common readme and disclaimer files are in the list of changed files, re-create the zip
        if [[ "$CHANGEDFILES" == *"$COMMONREADME"* ]] || [[ "$CHANGEDFILES" == *"$COMMONDISCLAIMER"]]; then
            echo "at 2"
            zip_needed=true;
        fi

        echo "category/cp  = $category/$cp"
        #  check the list of changed files in this commit to see if this Custom Partition has changed
        if [[ "$CHANGEDFILES" == *"$category/$cp"* ]] ; then
            echo "at 3"
            zip_needed=true;
        fi


        #  create the structure needed, then zip the file to the correct location
        if $zip_needed; then
          echo "Zip needed for cp: $cp"
          cd $cp
          foldername=`grep -i "cp=" *.sh`
          foldername=${foldername/*\//}
          foldername=${foldername/\"/}
          echo "Folder name: $foldername"
          echo "Zip file: $zip_file"
          cpt="tmp"
          rm -rf $cpt
          mkdir $cpt
          mkdir "$cpt/igel"
          mkdir "$cpt/target"
          cp *.xml "$cpt/igel"
          cp *.inf "$cpt/target"
          cp *.sh "$cpt/target"
          cp *.md "$cpt/target"
          cp -R !(*.xml|*.inf|*.sh|*.md|$cpt) "$cpt/target"
          cp $COMMONREADME "$cpt"
          cp $COMMONDISCLAIMER "$cpt"
          cd $cpt
          zip -r $zip_file .
          cd ..
          rm -rf $cpt
          cd ..
        fi

      fi

    done

    cd ../..

done
