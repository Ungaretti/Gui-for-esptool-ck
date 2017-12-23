Red [
	Title: "Esptool-ck-GUI"
	Author: A. Ungaretti
	Version 1.0
	Date-released: 23/12/2017
	needs 'view
]

;---------- Functions ----------;

funcGetComPorts: 
; Uses the cmd prompt to obtain the COM ports available
	has[cmdOutput b c i] [         ;com-ports is made global
	cmdOutput: ""				   ;this will hold the output from cmd as text
	clear cmdOutput    
	com-ports:[]                   ;this series will contain the COM ports
	clear com-ports []
	call/output "mode" cmdOutput   ;writes "mode" at cmd and puts answer in a block "cmdOutput"
	trim/with cmdOutput "-"        ;removes all "-" otherwise they are "glued" to COM text
	cmdOutput: split cmdOutput " " ;splits cmdOutput into a series
	foreach i cmdOutput [          ;gets the numbers of the ports
		b: copy/part i 3
		if b = "COM" [
			c: copy/part i 4
			append com-ports c
		]
	]
]

funcGetBinFile: 
; selects and uploads the binary file to be flashed
	has[][
	binFileName: request-file/filter ["BIN files" "*.bin"]
	filename: to string! binFileName          ;must be a string for manipulation
	filename: find/last/tail filename "/"     ;the name of the file without path
	fieldFilename/text: copy filename
]

funcCreateNewFile:
; changes the original file's 4th byte according to 
; the memory selected and saves this new file
	has[][
	switch dropMemorysize/text [
		"512K"  [h: 0]
		"256K"	[h: 1]
		"1M"	[h: 2]
		"2M"	[h: 3]
		"4M"	[h: 4]
		"8M"	[h: 8]
		"16M"	[h: 9]
	]
	byte: h * 16 + l
	poke binFile 4 byte
	write/binary %NewBinary.bin binFile
	view [
		text "NewBinary.bin created" rate 1
		on-time [unview]
	]
	exit
]

funcWrongMem:
; The selected .bin file's 4th byte does not match selection
	has[][
	view [
		;size 250x400
		below
		h4 200 center "Alert!"
		text 220x100 "The selected file is NOT for the memory size you chose. I can create a proper file if you want. This new file will be called NewBinary.bin and will be saved in the same directory as the original file."
		across
		button " Exit " [unview exit]
		button "Create new file"[
			funcCreateNewFile
			unview
		]
	]
]

funcCheckMem:
; Checks if the selected file 4th byte matches memory selection
	has[][
	binFile: read/binary  binFileName
	byte: pick binFile 4
	l: remainder byte 16
	h: byte / 16
	if any [
		(h = 0) and (dropMemorysize/text <> "512K")
		(h = 1) and (dropMemorysize/text <> "256K")
		(h = 2) and (dropMemorysize/text <> "1M") 
		(h = 3) and (dropMemorysize/text <> "2M") 
		(h = 4) and (dropMemorysize/text <> "4M") 
		(h = 8) and (dropMemorysize/text <> "8M")
		(h = 9) and (dropMemorysize/text <> "16M")
		]
		[readyFlag: false
		funcWrongMem]
]

funcFlashEsp:
; Create and send to cmd a proper command line string to esptool.exe
	has[][
	if dropComPort/text = "Choose:" [      ;checks if a COM port was selected
		view [
			text "No COM port selected"
			button "OK"[unview exit]
		]
	]
	funcCheckMem
	either readyFlag [
		command: []
		append command "esptool.exe -vv -cd nodemcu -cb"
		append command dropBaudRate/text
		append command "-cp"
		append command dropComPort/text
		append command "-ca 0x00000 -cf"
		append command fieldFilename/text
		print command
		call/shell/show form command
		clear command
	][exit]
]

; ---------- Main ----------;

funcGetComPorts
readyFlag: true

view [
	title "Esptool-ck GUI"
	
	text right "Serial port:"
	dropComPort: drop-down 200 "Choose:" data: copy com-ports
	button "Scan ports" 70 [
		funcGetComPorts
		dropComPort/data: copy com-ports]
	return
	text right "File to flash:"
	fieldFilename: field 200
	button "Browse" 70 [funcGetBinFile]
	return
	text right "Memory size:" 
	dropMemorysize: drop-down 70 data ["512K" "256K" "1M" "2M" "4M" "8M" "16M"]
		do [dropMemorysize/selected: 5 
		dropMemorysize/text: pick (dropMemorysize/data) dropMemorysize/selected]
	return
	text right "Baud rate:" 
	dropBaudRate: drop-down 70 data ["9600" "57600" "74880" "115200" "230400" "921600"]
	do [dropBaudRate/selected: 6 
		dropBaudRate/text: pick (dropBaudRate/data)
		dropBaudRate/selected
	]
	return
	button "Flash it!" [
		funcFlashEsp
		readyFlag: true
	]
]

