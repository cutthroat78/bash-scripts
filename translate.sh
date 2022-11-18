#!/bin/bash

option=$(echo -e "Text\nImage" | dmenu -i -p "Text or Image?")
save=$(echo -e "Yes\nNo" | dmenu -i -p "Save?")
audio=$(echo -e "Yes\nNo" | dmenu -i -p "Play and Download Audio?")
if [ $save = "Yes" ] || [ $audio = "Yes" ]
then
    filename=$(echo | dmenu -i -p "Filename for .mp3 and/or .txt")
fi
sentence=$(echo -e "Yes\nNo" | dmenu -i -p "Find Sentence?")
image=$(echo -e "Yes\nNo" | dmenu -i -p "Find Image?")
sourcelang=$(echo -e "Detect" | dmenu -i -p "Source Language (ISO 639-2)?")
targetlang=$(echo -e "Auto" | dmenu -i -p "Target Language (ISO 639-2)?")

if [ $sourcelang = "Detect" ] && [ $targetlang = "Auto" ]
then
    transcommand="trans"
fi
if [ $sourcelang = "Detect" ] && [ $targetlang != "Auto" ]
then
    transcommand="trans -t $targetlang"
fi
if [ $sourcelang != "Detect" ] && [ $targetlang = "Auto" ]
then
    transcommand="trans -s $sourcelang"
fi
if [ $sourcelang != "Detect" ] && [ $targetlang != "Auto" ]
then
    transcommand="trans -t $targetlang -s $sourcelang"
fi 

if [ $audio = "Yes" ]
then
    transcommand="$transcommand -speak -download-audio"
fi

savecommand=""

if [ $save = "Yes" ] 
then
    savecommand="| tee -a ~/'$filename'.txt"
fi

if [ $option = "Text" ] 
then
    text=$(echo '"' && echo | dmenu -i -p "Text" && echo '"')
    kitty --detach --hold sh -c "$transcommand $text $savecommand"
fi

if [ $option = "Image" ] 
then
    rm ~./ocr.txt
    flameshot gui
    ocrlang=$(echo -e "Detect\n$(tesseract --list-langs | tail -n +2)" | dmenu -i -p "Language for OCR?")
    if [ $ocrlang = "Detect" ]
    then
        tesseract ~/.ocr.png ~/.ocr
    fi
    if [ $ocrlang != "Detect" ]
    then
        tesseract -l $ocrlang ~/.ocr.png ~/.ocr
    fi
    text=$(echo '"' && cat ~/.ocr.txt && echo '"')
    kitty --detach --hold sh -c "kitty icat ~/.ocr.png && $transcommand $text $savecommand"
fi

if [ $audio = "Yes" ]
then
    ffmpeg -i ~/*.ts -vn -ar 44100 -ac 2 -b:a 192k ~/"$filename".mp3
    rm ~/*.ts
fi

if [ $sentence = "Yes" ]
then
    sentencelookup=$(echo -e $text | dmenu -i -p "Sentence Search Term")
    sentencelang=$(echo -e "fra\neng" | dmenu -i -p "Sentence Language (ISO 639-3)?")
    firefox "https://tatoeba.org/en/sentences/search?query=$sentencelookup&has_audio=yes&from=$sentencelang"
fi

if [ $image = "Yes" ]
then
    imagelookup=$(echo -e $text | dmenu -i -p "Image Search Term")
    firefox "https://duckduckgo.com/$imagelookup?iax=images&ia=images"
fi
