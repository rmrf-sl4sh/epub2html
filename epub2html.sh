#/bin/bash

#-- If user calls script incorrectly, let them know how to call it and exit
if [ $# -ne 0 ];
then
  echo "Run this script while working in the directory containing the .epubs you would like to convert to .html"
  echo ""
  echo "Usage: $0";
  echo ""
  exit -1
fi

#-- Define variable $fcount as 0
fcount=0

#-- Start for loop and assign the variable $f as each .epub file in the current working directory
for f in *.epub;
do
  #-- Increase the variable $fcount by 1 (this will tell the user how many .epub files there are in the directory)
  fcount=$(( fcount+1 ))
done

#-- Let user know how many .epubs are found
echo "[:] Total *.epub files detected: $fcount"
#-- Ask user if they are ready to begin
echo "[:] Start conversion of *.epub files to html format? (y/n) "
read -p "" REPLY

#-- If user replies with Y or y, continue
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  #-- If the user replies with anything other than Y or y, exit
  echo "[:] Complete."
  exit 1
fi

#-- Rename all files, replace spaces with - to prevent errors while processing
for f in *\ *;
do
  mv "$f" "${f// /-}"
done

echo "[:] Beginning conversion of .epub files..."
#-- Create directory 'old' in the current working directory (this is where processed .epub files will be moved to)
mkdir ./old

#-- Define the function "max" to limit the number of concurrent conversion jobs to 5
function max {
   while [ `jobs | wc -l` -ge 5 ]
   do
      wait
   done
}

#-- Define the function "convert" for converting .epubs to .htmlz archives
convert () {
  #-- Define variable $fout as the current filename in variable $f, and cut the leading directory name off of it
  fout=$(basename "$f" .epub)
  #-- Run calibre (ebook-convert) on current file and process with the options listed
  ebook-convert $f $fout.htmlz --pretty-print --margin-left=200 --margin-right=200 --change-justification=justify --smarten-punctuation --base-font-size=14
  #-- Define variable $farch as the basename of the file in variable $f
  farch=$(basename "$f")
  #-- Move processed file to the ./old directory
  mv "$f" "./old/$farch"
  #-- Let user know that the file has been archived
  echo ""
  echo "[:] Archived $farch to ./old"
}

#-- Start for loop and assign the variable $f as each .epub file in the current working directory
for f in *.epub;
do
  #-- Use the convert() function defined earlier
  echo ""
  #-- This calls the convert function, and sends the process to the background. It will start a new process every 1 second until it works its way through all .epub files.
  max; convert &
  #-- If you have a system that cannot handle converting many files in parallel, increase the sleep amount below:
done
wait
echo "[:] All conversions completed, unzipping .htmlz files..."
#-- Begin the for loop and assign each *.htmlz archive name to the variable $file
for f in *.htmlz;
do
  #-- Extract each .htmlz archive to a subfolder named after the archive
  unzip $f -d $(basename "$f" .htmlz)
#-- Script complete.
done
echo "[:] Complete."
exit 1