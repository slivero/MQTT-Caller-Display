/*
 * Quick arduino sketch to recieve a telephone number over 
 * serial (1200 baud using hardware serial) and broadcast it
 * using MQTT.
 *
 * This sketch is part of a project to read caller id data from
 * a BT Caller Display 50.
 *
 * @author Oliver Smith
 * 
 */

#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>

byte mac[]    = { 0xDE, 0xED, 0xBA, 0xFE, 0xFE, 0xED };
byte server[] = { 192, 168, 1, 2 };
byte ip[]     = { 192, 168, 1, 8 };

PubSubClient client(server, 1883, callback);

const int bufferLength = 19;      //Length of buffer
char stringBuffer[bufferLength];  //Buffer to hold input
int stringIndex = 0;              //Index of next free element in buffer

void setup()
{
  Serial.begin(1200);
  Serial.println("Serial Connected");

  Ethernet.begin(mac, ip);
  Serial.println("Network Connected");

  if(client.connect("arduino"))
  {
    Serial.println("MQTT Connected");
  }
}

void loop()
{ 
  while(Serial.available() && stringIndex < bufferLength)
  {
    char inputChar = Serial.read();

    //Check if the char read is a number
    if(inputChar  >= '0' && inputChar <= '9' )
    { 
        //Add number to buffer
        stringBuffer[stringIndex] = inputChar;

      //Serial.println(stringBuffer);
      stringIndex++;
    }
  }

  //If the buffer is long enough
  if(stringIndex == bufferLength)
  {    
    //convert the 
    String output = String(stringBuffer);
    
    //remove initial irrelevant digits
    String telephoneNumberString = output.substring(8); 

    //convert back to char arry for sending
    char charBuf[12];
    telephoneNumberString.toCharArray(charBuf, 12);

    //Send the telephone number back over serial for debugging
    Serial.println(charBuf);
    client.publish("topic",charBuf);
    
    //reset the index ready for next time
    stringIndex = 0;
  }
}



void callback(char* topic, byte* payload,int length) {
  // handle message arrived
}





