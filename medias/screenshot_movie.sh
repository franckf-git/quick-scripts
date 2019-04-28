for i in $(ls)
do
ffmpeg -ss 00:05:00 -t 1 -i $i $i.png
done