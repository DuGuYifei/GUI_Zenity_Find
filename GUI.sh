#!/bin/sh
#Yifei Liu 188026

zenity --password --username --title="This is a secret" > output
U=$(awk -F "|" '{print $1}' output);
P=$(awk -F "|" '{print $2}' output);

if [ "$U" != "producer" -o "$P" != "pig" ]
then
	echo Wrong username or password
	exit
fi

Filename=""
Catalogname=""
Username=""
Min=""
Max=""
Typeofdocument=""
Content=""
YorN=""
#declare parameters
const=0
#give a number at will to get into loop
while [ $const -ne  1 ]
do

Option=$(zenity --list --title="SearchingBox" --text="Choose searching options" --height 390 --width 500 --column=SearchingOption "1. Filename" "$Filename" "2. Catalog" "$Catalogname" "3. User" "$Username" "4. Size" "Min:$Min Max:$Max" "5. Type" "$Typeofdocument" --column=Value "6. File content" "$Content" "SEARCH" "" "FINISH" "" "light version" "");
#list used to choose option

#case used to execute the option
case "$Option" in
	"1. Filename")
		Filename=$(zenity --entry --title="FileName" --text="Enter the file name(case sensitive)");
		if [ -n "$Filename" ]       
		then 
		        filename=" -name $Filename"
		else
		        filename=" "
	        fi
	;;
	
	"2. Catalog")
		zenity --info --title="Catelog" --width 320 --text="Tip:
./	current catalog
/	the whole catalog
default is current catalog" 
		Catalogname=$(zenity --entry --title="Catalog" --text="Enter the catalog" --width 320);
		if [ -n $Catalogname ]
		then
			catalogname="$Catalogname"
		else
			catalogname=" "
		fi
        ;;   

	"3. User")
		Username=$(zenity --entry --title="Username" --text="Enter the user");
		if [ -n "$Username" ]
		then
		        username=" -user $Username"
		else
			username=" "
		fi
        ;;

	"4. Size")
		zenity --info --title="Size" --text="1Mb=1024kb=2048sector"
		zenity --forms --title="Size" --text="Enter Min and Max" --add-entry="Minsize (sector)" --add-entry="Maxsize (sector)" --separator="," > output
		Min=$(awk -F "," '{print $1}' output);
		Max=$(awk -F "," '{print $2}' output);
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
	;;

	"5. Type")
		zenity --info --title="Type" --width 150 --text="f	file
d	document
l	soft link"
		Typeofdocument=$(zenity --entry --title="Type" --text="Enter the Type" --width 320);
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
			 zenity --warning --text="No such type"
		         typeofdocument=""
		fi	 

	;;

	"6. File content")
		zenity --info --title="File content" --height 100 --width 400 --text="You can see the lines which contain the content."
		Content=$(zenity --entry --title="File content" --text="Enter file content" --width 320);
		if [ -n "$Content" ]
		then
			content=" -exec grep $Content {} -Hn ;"
		else
			content=" "
		fi

	;;

	"SEARCH")
		find $catalogname$filename$username$minimax$typeofdocument$content > output|
		zenity --progress --title="Serching" --text="ψ(´∇´)ψ Please wait..." --percentage=0 --width 320 
		zenity --text-info --title="Search Result" --filename="output" --width 1000 --height 500 --editable
	;;
        
        "FINISH")
		if ( zenity --question --width 320 --title="Don't leave me" --text="Are you sure to leave me alone cruelly" )
		then
			break
		fi
        ;;

"light version")
zenity --forms --title="SearchingBox light version" --text="Enter the parameters"\
        --separator=","\
	--width 320\
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
else														                if [ "$Max" != "" ]
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
zenity --text-info --title="Search Result" --filename="output" --width 1000 --height 500 --editable
;;


esac

done 
