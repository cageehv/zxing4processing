/*****************************************************************************
 *
 *  QRCodeReadeerCam - v07/26/2018
 *
 *  An example of the use of the ZXING4P.decodeImage() method.
 *
 *  Opens a webcam and tries to find QRCodes in the cam captured images
 *  using the ZXING4P.QRCodeReader() method.
 *
 *  When a QRCode is detected it will display the decoded text.
 *
 *  Run this sketch and hold a printed copy of a QRCode in front of the cam.
 *
 *  Note: make sure your video image is NOT mirrored! It won't detect QRCodes
 *  that way...
 *
 *  Library page:
 *  http://cagewebdev.com/zxing4processing-processing-library/
 *
 *  (c) 2013-2018 Rolf van Gelder, http://cagewebdev.com, http://rvg.cage.nl
 * 
 *****************************************************************************/

// IMPORT THE ZXING4PROCESSING LIBRARY AND DECLARE A ZXING4P OBJECT
import com.cage.zxing4p3.*;
ZXING4P zxing4p;

// PROCESSING VIDEO LIBRARY
import processing.video.*;
Capture video;

String decodedText;
String latestDecodedText = "";

int txtWidth;


/*****************************************************************************
 *
 *  SETUP
 *
 *****************************************************************************/
void setup() {
  size(640, 480);

  // LAYOUT
  textAlign(CENTER);
  textSize(30);

  // CREATE CAPTURE
  video = new Capture(this, width, height);

  // START CAPTURING
  video.start();  

  // CREATE A NEW EN-/DECODER INSTANCE
  zxing4p = new ZXING4P();

  // DISPLAY VERSION INFORMATION
  zxing4p.version();
} // setup()


/*****************************************************************************
 *
 *  DRAW
 *
 *****************************************************************************/
void draw() { 
  background(0);

  // UPDATE CAPTURE
  if (video.available()) video.read();

  // DISPLAY VIDEO CAPTURE
  set(0, 0, video);

  // DISPLAY LATEST DECODED TEXT
  if (!latestDecodedText.equals("")) {
    txtWidth = int(textWidth(latestDecodedText));
    fill(0, 150);
    rect((width>>1) - (txtWidth>>1) - 5, 15, txtWidth + 10, 36);
    fill(255, 255, 0);
    text(latestDecodedText, width>>1, 43);
  } // if (!latestDecodedText.equals(""))

  // TRY TO DETECT AND DECODE A QRCODE IN THE VIDEO CAPTURE
  // QRCodeReader(PImage img, boolean tryHarder)
  // tryHarder: false => fast detection (less accurate)
  //            true  => best detection (little slower)
  try {  
    decodedText = zxing4p.QRCodeReader(video, false);
  } 
  catch (Exception e) { 
    decodedText = "";
  } // try

  if (!decodedText.equals("")) {
    // FOUND A QRCODE!
    if (latestDecodedText.equals("") || (!latestDecodedText.equals(decodedText)))
      println("Zxing4processing detected: "+decodedText);
    latestDecodedText = decodedText;
  } // if (!decodedText.equals(""))
} // draw()
