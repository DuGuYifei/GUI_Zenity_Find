#!/bin/sh
#Yifei Liu 188026

zenity --forms --title="SearchingBox light version" --text="Enter the parameters"\
	--separator=","\
	--add-entry="Filename"\
	--add-entry="Catalog"\
	--add-entry="User"\
	--add-entry="Size-min"\
	--add-entry="Size-max"\
	--add-entry="Type"\
	--add-entry="Content" > info
	Filename=$(awk -F "," '{print $1}' info);
	Catalogname=$(awk -F "," '{print $2}' info);
	Username=$(awk -F "," '{print $3}' info);
	Min=$(awk -F "," '{print $4}' info);
	Max=$(awk -F "," '{print $5}' info);
	Typeofdocument=$(awk -F "," '{print $6}' info);
	Content=$(awk -F "," '{print $7}' info);
zenity --question --title="SearchingBox light version" --text="Are you ready to search?" --width 350

if [ -n "$Filename" ]       
then
	filename=" -name $Filename"
else
        filename=" "
fi

if [ -n $Catalogname ]
then
        catalogname="$Catalogname"
else
        catalogname=" "
fi
 
if [ -n "$Username" ]
then
	username=" -user $Username"
else
	username=" "
fi
   
if [ "$Min" != "" ]
then
	 if [ "$Max" != "" ]
	 then
		 minimax=" -size +$Min -a -size -$Max"
	 else
		 minimax=" -size +$Min"
	 fi
 else
	 if [ "$Max" != "" ]
	 then
		 minimax=" -size -$Max"
	 else
		 minimax=""
	 fi
fi

if [ "$Typeofdocument" = "f" ]
then
	typeofdocument=" -type f"
elif [ "$Typeofdocument" = "d" ]
then
	typeofdocument=" -type d"
elif [ "$Typeofdocument" = "l" ]
then
	typeofdocument=" -type l"
elif [ "$Typeofdocument" = "" ]
then
	typeofdocument=" "
else
	Typeofdocument="No such type"
	typeofdocument=""
fi

if [ -n "$Content" ]
then
	content=" -exec grep $Content {} -Hn ;"
else
	content=" "
fi

find $catalogname$filename$username$minimax$typeofdocument$content > output
zenity --text-info --title="Search Result" --filename="output" --width 1000 --height 200 --editable
