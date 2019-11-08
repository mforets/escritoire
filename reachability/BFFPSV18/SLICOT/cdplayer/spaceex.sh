#!/bin/bash
#
# Info: You need the tool 'graph', 'spaceex', and 'pdftoppm' added to your path.

NAME=cdplayer
PLOTS_FOLDER=plots
if [ -z "$1" ]; then
	ADDITIONAL_ARGUMENTS=""
else
	ADDITIONAL_ARGUMENTS="$1"
fi

# run SpaceEx
spaceex -m $NAME.xml -g $NAME.cfg $ADDITIONAL_ARGUMENTS

PLOT_NAME=$(grep "output-file" $NAME.cfg | sed 's/^[^"]*"\([^"]*\)".*/\1/' | sed 's/.txt//')

# to PS
graph -T "ps" -BC -q 0.5 $PLOT_NAME.txt > $PLOT_NAME.ps

# to PDF
ps2pdf -dEPSCrop $PLOT_NAME.ps $PLOT_NAME.pdf

# to PNG
pdftoppm -png -singlefile $PLOT_NAME.pdf $PLOT_NAME

# remove non-PDF plot files
rm $PLOT_NAME.ps

if [[ ! -e $PLOTS_FOLDER ]] ; then mkdir $PLOTS_FOLDER
fi

mv $PLOT_NAME.* $PLOTS_FOLDER/