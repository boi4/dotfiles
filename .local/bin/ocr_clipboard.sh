#!/bin/bash
##https://askubuntu.com/a/280713
#tesseract_lang=eng
#
#SRC_IMG=`mktemp`
#trap "rm $SRC_IMG*" EXIT
#
#scrot -s $SRC_IMG.png -q 100
## increase image quality with option -q from default 75 to 100
#
#mogrify -modulate 100,0 -resize 400% $SRC_IMG.png
##should increase detection rate
#
#tesseract $SRC_IMG.png $SRC_IMG &> /dev/null
#cat $SRC_IMG.txt | xsel -bi
#!/bin/bash
#set -v
tesseract_lang=eng

# Create a temporary file for the screenshot
SRC_IMG=$(mktemp --suffix=.png)
#echo $SRC_IMG
trap "rm -f $SRC_IMG" EXIT

# Take a screenshot using hyprshot (requires interaction for selection)
hyprshot -o / -f /$SRC_IMG -m region

# Improve image quality for better OCR detection
mogrify -modulate 100,0 -resize 400% "$SRC_IMG" >/dev/null

# Run OCR on the image
tesseract -l lit+eng "$SRC_IMG" "$SRC_IMG" >/dev/null #&> /dev/null >/dev/nu

# Copy the result to the clipboard using wl-copy
#echo cat "$SRC_IMG.txt"
#cat "$SRC_IMG.txt"
cat "$SRC_IMG.txt" | wl-copy
