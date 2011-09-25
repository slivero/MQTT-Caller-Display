# MQTT Caller Display

A simple hardware hack which uses an arduino to broadcast the telephone number of incoming calls using MQTT, the telephone numbers are provided by a BT caller display 50 unit.

*Further details of the Software and Hardware will appear when I've had chance to write them up, probably in the form of a blog post at http://chemicaloliver.net*

## Principles 

### Caller Display (UK only)
The caller id system in the UK transmits the callers telephone number (and date and time) as a burst of 1200 baud serial between the first and second ring this is decoded and displayed.

### MQTT

MQTT is a lightweight messaging protocol developed by IBM which is now becoming increasingly common in home automation systems. More information can be found at MQTT.org

## Hardware

### The BT Caller Display 50
The BT caller display 50 uses an (actually two but one is irrelevant) EXAR XR-2211 FSK Demodulator/ Tone Decoder which in this application has a 1200 buad serial output as it's data out (DO). All that's required is to solder onto pin 7 (DO) and a pin for power.

### Isolating Bridge

Telephone lines can carry voltages dangerous to computers so an optoisolator is used between the caller display unit and Arduino. In this case I used the Vishay 6N137, taking power on the CD50 side from the unit itself to preserve isolation.

### Arduino

The Arduino used was a standard duemilanove with the official ethernet shield, this processes the data from the CD 50 and broadcasts it as an MQTT message.

###  History

The circuit used seems to be a duplicate of a previous project which was documented at http://www.amarok.demon.co.uk/dl/cd50_mod/ and http://www.photon.dyndns.org/projects/btcd50conversion/old_index.html however these pages are long gone and the wayback machine only has the text not the images detailing the hardware. I never managed to find a copy of them so I built my own version.

## Software

The software simply listens for serial on the hardware serial port, when 19 digits (seems to be the standard length of the messages from BT) have been recieved the software parses off the first 10 digits which transmit the date and time and then broadcasts the number as an MQTT message.

### Dependencies

* Arduino MQTT Library - http://knolleary.net/arduino-client-for-mqtt/
