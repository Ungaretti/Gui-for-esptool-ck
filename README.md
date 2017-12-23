# Gui-for-esptool-ck
A program written in Red language to create a GUI for flashing NodeMcu boards with esptool-ck in Windows

<img src="https://github.com/Ungaretti/ungaretti.github.io/blob/master/assets/esptoolGUI/Screenshot.png">

[Esptool-ck](https://github.com/igrr/esptool-ck) is a program writen in C to flash firmware to the ESP8266. Don't confuse it with exptool.py, a python program that does pretty much the same thing, but requires python installed in your computer.

Esptool-ck is small, versatile, but it's a CLI program, that is, no Graphic User Interface. I wrote this script in Red to give it a basic interface to be used with NodeMcu boards and Windows.

Pros: 
* detects serial ports available (up to COM9 only)
* checks to see if the binary file was made for the memory size you selected and **patches the file if needed!**

Cons:
* NodeMcu boards only. As it is, it uses the nodemcu reset mode from esptool-ck.
* Windows only. As it is, it interfaces with windows command prompt.

You may change these issues in the code if you feel like it.

Download the esptool-ck release from: https://github.com/igrr/esptool-ck/releases
Download the Red Language interpreter from: http://www.red-lang.org/p/download.html
Get your NodeMcu firmware binary from: https://nodemcu-build.com/

Create a folder and add to it:
* the red interpreter
* the Esptool-ck-GUI.red source file
* the esptool-ck' esptool.exe executable
* the binary file you want to flash

You should end up with something like this:

<img src="https://github.com/Ungaretti/ungaretti.github.io/blob/master/assets/esptoolGUI/folderview.png">

