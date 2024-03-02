#!/bin/bash

function scanDir {
	sourceDir="$1"
	targetDir="$2"

	#Move to the sourceDir to parse the files there.

	cd $sourceDir
	for file in *.c
	do

		#Print the file that we are working with right now.

		echo "----->>>" $file "<<<-----"

		#Get the name of the file with no extension.

		compiledFileName=${file%.*}

		#Compile the C script in the targetDir.

		gcc -o ../$targetDir/$compiledFileName $file

		#Retrieve and test the return code.

		returnCode="$?"
		if test $returnCode -eq 0;
		then
			echo "Success in compiling " $file " file"
			echo "The output is: "

			#Just regularlly run the resulted executable in
			#the targetDir.

			output=$(../$targetDir/$compiledFileName)
			echo $output

			#Open the file with cat and concatenate
			#the contents in one string.

			expectedOutput=$(cat $compiledFileName.out)
			
			#Check if the received output is the same as the one
			#in the output file.

			if test "$output" == "$expectedOutput";
			then
				echo "Valid output from file" $file 
			else
				echo "Invalid output from file " $file
			fi

		#Case of error in compilation.
		#Print the return code and the error itself from GCC

		else
			echo "Failure in compiling " $file " file"
			echo "Return code is: " $returnCode
		fi
	done
}


sourceDir="$1"
targetDir="$2"
argc="$#"

#Sanitize the inputs to make sure the script received 2 valid directories

if test $argc -lt 2;
then
	echo "Please provide 2 directories!"
	exit -1
fi
if ! test -d $sourceDir;
then
	echo "Please provide a valid source directory!"
	exit -1
else
	if ! test -d $targetDir;
	then
		echo "Please provide a valid target directory!"
		exit -1
	else
		scanDir $sourceDir $targetDir
	fi
fi
