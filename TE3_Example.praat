#! praat
# 
# Example Praat script to process all TextGrid files in a folder.
#
# Copyright: R.J.J.H. van Son, 2019
# License: GNU GPL v2
# email: r.v.son@nki.nl
# 
#     TE3_Example.praat: Praat script to process all TextGrid files. 
#     
#     Copyright (C) 2019  R.J.J.H. van Son and the Netherlands Cancer Institute
# 
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
# 
# 
# The form window will pop up and ask for the source of the TextGrids and 
# the number of the Tier
form Process all TextGrids
	comment A pop-up window will ask you to select a folder to process
	comment 
	sentence TextGrid_Files *.TextGrid
	positive Tier_(number) 1
endform

# Write text to Info window
writeInfoLine: "Choose a directory to read all TextGrids from"
# Set pen color
Red
# Paint text in Picture Window
Text special: 0.5, "Centre", 0.5, "Half", "Times", 20, "0", "Choose a directory to read all TextGrids from"

# Ask for a directory
sourceDirectory$ = chooseDirectory$: "Choose a directory to read all TextGrids from"
if sourceDirectory$ <> ""
	sourceDirectory$ = sourceDirectory$ + "/"
endif
textGrid_Files$ = sourceDirectory$ + "*.TextGrid"

# Reset Picture Window
Black
Erase all

# Start output
writeInfoLine: "File", tab$, "Int.", tab$, "Label", tab$, "Duration"
sourceDirectory$ = replace_regex$(textGrid_Files$, "[^/\\]*$", "", 0)

# List all TextGrids and iterate over them
textGridList = Create Strings as file list: "TextGridList", textGrid_Files$
numFiles = Get number of strings
for i to numFiles
	selectObject: textGridList
	textGridName$ = Get string: i
	elementName$ = replace$(textGridName$, ".TextGrid", "", 0)
	audioName$ = elementName$+".wav"

	# If the audio file exists, proceed
	if fileReadable(sourceDirectory$+audioName$)
		currentSpeech = Read from file: sourceDirectory$+audioName$
		currentTextGrid = Read from file: sourceDirectory$+textGridName$

		# Iterate over all intervals in the Tier
		numIntervals = Get number of intervals: tier
		for j to numIntervals
			selectObject: currentTextGrid
			label$ = Get label of interval: tier, j
			if label$ = ""
				label$ = "#" 
			endif
			startTime = Get start time of interval: tier, j
			endTime = Get end time of interval: tier, j
			
			################################################
			#
			# Measure or manipulate audio
			# (replace appendInfoLine with relevant action)
			#
			################################################
			
			# Print out durations
			appendInfoLine: elementName$, tab$, j, tab$, label$, tab$, fixed$(endTime - startTime, 3)
			
			################################################
			
		endfor
		
		# Clean up
		selectObject: currentSpeech, currentTextGrid
		Remove
	endif
endfor

# Clean up
selectObject: textGridList
Remove
