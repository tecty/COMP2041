#!/bin/bash
function selectName()
{
    # remove the first title in the square braket 
    sed "s?[0-9a-zA-Z() ]*|??g" | 
    # remove the square braket and quote
    tr -d "[]\"" |
    # replace the / to remove error 
    tr '\/' '-' |
    # remove the head and tail space 
    sed "s/^ //g" | sed "s/ $//g"
}


# wget -Omusic.html https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw

mkdir -p $2 

cat music.html |
    sed "s/# /#/g" |
    # grep the year of the albumn 
    egrep -A11 "\[\[Triple J Hottest 100, [0-9]{4}\|[0-9]{4}\]\]" |
    # remove the noice in the music name 
    tr -d "#" |
    # remove the noise in the file 
    sed -z "s/--\n//g" |
    sed -z "s/|\n//g" > music.tmp 

while read -r line   
do
    if 
        echo $line | 
        egrep "Triple J Hottest 100, [0-9]{4}\|[0-9]{4}" 2>&1 1>/dev/null 
    then
        # this is the line of albumn name 

        # fetch the album name 
        albumn=`echo $line | tr -d "'\[\]"| cut -d'|' -f3`
        # make the directory of the albumn
        mkdir -p -- "$2/$albumn" &
        # echo $albumn
        # renew the track counter 
        track_counter=1
    else
        # fetch the siner and song 
        singer=`echo $line | tr "–" "-" | cut  -d"-" -f 1 | selectName `
        song=`echo $line | tr "–" "-" | cut  -d"-" -f 4  | selectName`
        # generate the file name 
        fileName=`echo "$track_counter - $song - $singer.mp3"`
        
        # copy the sample to the file name 
        cp -- $1 "$2/$albumn/$fileName" &
        # this line contains the music name 
        # echo "$track_counter - $line" 
        # increment the tracker 
        ((track_counter++))
    fi
done < music.tmp 


    
