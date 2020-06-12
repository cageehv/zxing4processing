/*****************************************************************************
 *
 *  generateQRCode - QRCode generator - v07/26/2018
 *
 *  A simple example of the use of the ZXING4P.generateQRCode() method.
 *
 *  Enter a message that will be encoded in a QRCode and hit <enter>.
 *
 *  Press 's' to save the generated image (as a .gif file)
 *  Press 'r' to start again
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

PImage  QRCode;
PFont   font;

boolean generated = false;
boolean firstTime = true;

String  textToEncode = "";
boolean showCursor   = true;
int     lastTime     = 0;

/*****************************************************************************
 *
 *  SETUP
 *
 *****************************************************************************/
void setup() {
  size(600, 600);

  // ZXING4P ENCODE/DECODER INSTANCE
  zxing4p = new ZXING4P();

  // SHOW VERSION INFORMATION IN CONSOLE
  zxing4p.version();

  font = loadFont("ArialMT-18.vlw");
  textFont(font, 18);
} // setup()


/*****************************************************************************
 *
 *  DRAW
 *
 *****************************************************************************/
void draw() {
  background(102);

  if (generated) {
    // DISPLAY GENERATED IMAGE
    set(0, 0, QRCode);
  } else {
    // WAIT FOR USER INPUT
    fill(255);
    text("Type the text for your QRCode and press <enter> to generate the image:", 10, 15, width - 40, height);
    rect(0, 65, width, height);

    // MAKE CURSOR BLINK
    int t = millis();
    if (t - lastTime > 500) {
      showCursor = !showCursor;
      lastTime = t;
    }

    // DISPLAY USER INPUT
    fill(0);
    if (showCursor)
      text(textToEncode + "_", 10, 80, width - 40, height);
    else
      text(textToEncode, 10, 80, width - 40, height);
  } // if (generated)
} // draw()


/*****************************************************************************************
 *
 * CREATE A TIMESTAMP (YYYYMMDDHHMMSS)
 * 
 *****************************************************************************************/
String timeStamp() {
  return year()+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
} // timeStamp()


/*****************************************************************************
 *
 *  KEYBOARD HANDLER
 *
 *****************************************************************************/
void keyPressed() {
  if (generated) { 
    // IMAGE HAS BEEN GENERATED
    if (key=='s' || key=='S') { 
      // SAVE GENERATED IMAGE
      String ts = timeStamp();
      saveFrame(dataPath("")+"/qrcode_"+ts+".gif");
      println("QRCode image saved as data/qrcode_"+ts+".gif");
    } else if (key=='r' || key=='R') { 
      // RESTART
      generated = false;
      textToEncode = "";
    }
  } else { 
    // WAITING FOR USER INPUT
    if ((key == ENTER) || (key == RETURN)) {
      // ENCODE THE TEXT INTO A QRCODE IMAGE
      // PImage p = ZXING4P.generateQRCode(String txt,int width,int height)
      // width and height is the size of the generated image
      try {
        QRCode = zxing4p.generateQRCode(textToEncode, width, height);
        QRCode.save(dataPath("")+"/qrcode_tmp.gif");
        QRCode = loadImage("qrcode_tmp.gif");
      } 
      catch (Exception e) {  
        println("Exception: "+e);
        QRCode = null;
      }

      if (firstTime) {
        println("Press 's' to save the image to disk");
        println("Press 'r' to start again");
      }
      generated = true;      
      firstTime = false;
    } else if ((key > 31) && (key != CODED)) {
      // REGULAR CHARACTER: ADD TO STRING
      textToEncode = textToEncode + key;
    } else if ((key == BACKSPACE) && (0 < textToEncode.length())) {
      textToEncode = textToEncode.substring(0, textToEncode.length() - 1);
    }
  }
} // keyPressed() 
