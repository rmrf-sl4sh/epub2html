# epub2html
A linux shell script utilizing calibre to bulk convert .epub e-reader files into .html fully functional webpages

This script requires calibre. See https://github.com/kovidgoyal/calibre for information.
	
Call this script while working in the directory containing the .epub files you want to convert. Output is the working directory. Processed .epub files are moved into a directory named "./old".
	
The converting processes are put into the background and a new process for each .epub is started every one second. Change the duration of sleep in the corresponding loop if needed. I have been able to run this without a sleep call on a system with lots of processing power and RAM, but there are limitations. Adjust accordingly if so.