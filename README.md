# epub2html
A linux shell script utilizing calibre to bulk convert .epub e-reader files into .html fully functional webpages

This script requires calibre. See https://github.com/kovidgoyal/calibre for information.
	
Call this script while working in the directory containing the .epub files you want to convert. Output is the working directory. Processed .epub files are moved into a directory named "./old".
	
The converting processes are put into the background and a new process for each .epub is started, for a maximum of 5 concurrent jobs at one time. This can be adjusted by changing the following to suit your hardware:

	#-- Define the function "max" to limit the number of concurrent conversion jobs to 5
	function max {
	while [ `jobs | wc -l` -ge 5 ]
	do
	   wait
	done
	}
	
Change 5 to whatever number you prefer.