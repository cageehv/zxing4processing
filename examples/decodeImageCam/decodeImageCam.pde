/*****************************************************************************
 *
 *  decodeImageCam - v07/21/2016
 *
 *  Another example of the use of the zxing4p3.decodeImage() method
 *
 *  Opens a webcam and tries to find QRCodes in the cam captured images
 *  using the zxing4p3.decodeImage() method
 *
 *  When a QRCode is detected it will display the decoded text
 *
 *  Run this sketch and hold a printed copy of a QRCode in front of the cam
 *
 *  Note: make sure your video image is NOT mirrored! It won't detect QRCodes
 *  that way...
 *
 * (c) 2013-2016 Rolf van Gelder :: http://cagewebdev.com/ :: http://rvg.cage.nl
 * 
 */

// IMPORT THE zxing4p3 LIBRARY + DECLARE A ZXING4P OBJECT
import com.cage.zxing4p3.*;
ZXING4P zxing;

import processing.video.*;
Capture video;

String decodedText;
String lastDecodedText = "";

/*****************************************************************************
 * SETUP
 *****************************************************************************/
void setup()
{
  size(640, 480);

  textAlign(CENTER);
  textSize(40);

  // CREATE CAPTURE
  video = new Capture(this, width, height);

  // START CAPTURING
  video.start();  

  // CREATE A NEW EN-/DECODER INSTANCE
  zxing = new ZXING4P();
} // setup()


/*****************************************************************************
 * DRAW
 *****************************************************************************/
void draw()
{ 
  background(0);

  // UPDATE CAPTURE
  if (video.available()) video.read();

  // DISPLAY VIDEO CAPTURE
  set(0, 0, video);

  text(lastDecodedText, width>>1, 50);

  // TRY TO DETECT AND DECODE A QR-CODE IN THE VIDEO CAP
  // decodeImage(boolean tryHarder, PImage img)
  // tryHarder: false => fast detection (less accurate)
  //            true  => best detection (little slower)
  try
  {  
    decodedText = zxing.decodeImage(false, video);
  }
  catch (Exception e)
  {  
    println("Exception: "+e);
    decodedText = "";
  }

  if (!decodedText.equals(""))
  {  // FOUND A QRCODE!
    lastDecodedText = decodedText;
  }
} // draw()