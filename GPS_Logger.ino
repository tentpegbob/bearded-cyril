/*
   Arduino IDE Sketch File
   Log GPS NMEA data to an SD card every second

   This code was adapted from the http://www.instructables.com/id/HackerBoxes-0021-Hacker-Tracker/
   Direct link available at:
     https://cdn.instructables.com/ORIG/FPO/5H2Z/J5CQ8DGH/FPO5H2ZJ5CQ8DGH.ino
*/

#include <SoftwareSerial.h>
#include <SPI.h>
#include <SD.h>


// Arduino pins used by the GPS module
static const int GPS_RXPin = A1;
static const int GPS_TXPin = A0;
static const int GPSBaud = 9600;

// Arduino pin for SD Card
static const int SD_ChipSelect = 4;

// The GPS connection is attached with a software serial port
SoftwareSerial Gps_serial(GPS_RXPin, GPS_TXPin);
File dataFile;

void setup()
{ 
  // Open the debug serial port at 9600
  Serial.begin(9600);

  // Open the GPS serial port
  Gps_serial.begin(GPSBaud);

  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(SD_ChipSelect, OUTPUT);

  // see if the card is present and can be initialized:
  if (!SD.begin(SD_ChipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");

  dataFile = SD.open("gps.txt", FILE_WRITE);
  // if the file is available, write to it:
  if (dataFile) {
    Serial.println("opened gps.txt");
  }
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening gps.txt");
  }
}

/*
 * The NMEA standard specifies that GPS interfaces operate at a standard of 4800 bits per second.
 * At 4800 b/s you can only send 480 characters in one second. An NMEA sentence can be as long as 
 * 82 characters you can be limited to less than 6 different sentences
 */
static String strBuffer;
static const char MAGIC_WORD [] = "$GP";

void loop()
{
  if (Gps_serial.available())
  {
    strBuffer.concat(char(Gps_serial.read()));

  /*
   * read up to 100 characters or we've begun reading anther line by observing another 
   * magic header value $GP, since every sentence begins with $GP. Eight (8) is chosen
   * as the magic string buffer length because each sentence can begin with a "$"
   * followed by 5 UPPERCASE letters describing the name of the sentence. This leaves
   * a little bit of padding so we don't accidently cutoff a sentence.
   */
    if (strBuffer.endsWith(MAGIC_WORD) && (strBuffer.length() > 8))
    {
      // Remove the magic header, add a null terminator - if needed
      strBuffer.remove(strBuffer.lastIndexOf(MAGIC_WORD));
      if(!strBuffer.endsWith("\n"))
        strBuffer.concat("\n");

      //Here for observing the data over the serial monitor in Arduino Serial Monitor
      /*
       * Here we have decided to comment out the detailed satellite information, which
       * tells us how many satellites are in view, PRN satellite number, elevation/azimuth,
       * and signal-to-noise ratio (SNR). If you want that information just comment out
       * the if statement below after this block comment.
       */
      Serial.write(strBuffer.c_str());
       /* 
       * here you could do something optional like only write essential fix data
       * by add an if statement for something like if (strBuffer.startsWith("$GPGGA")) 
       * a table of gps sentence keywords are available @ http://www.gpsinformation.org/dale/nmea.htm#GSA
       */
      dataFile.write(strBuffer.c_str());
      strBuffer = MAGIC_WORD;
    }
  }
}
