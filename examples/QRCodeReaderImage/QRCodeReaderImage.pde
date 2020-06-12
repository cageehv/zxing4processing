/*****************************************************************************
 *
 *  QRCodeReaderImage - v07/26/2018
 * 
 *  A simple example of the use of the ZXING4P.QrCodeReader() and
 *  ZXING4P.getPositionMarkers() methods.
 *
 *  Opens a photo and uses the ZXING4P.decodeImage() method to find and decode
 *  QRCode images in that photo.
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

// THE POSITION MARKERS OF THE DETECTED QR-CODE IN THE IMAGE
PVector[] markers = null;

PFont  font;

// SOME PICTURES FOR TESTING
ArrayList<PImage> photos = new ArrayList();
int    currentPhoto = 0;

String decodedText = "";
String txt;
int    txtWidth;

boolean dumped = true;


/*****************************************************************************
 *
 *  SETUP
 *
 *****************************************************************************/
void setup() {
  size(640, 480);

  // CREATE A NEW EN-/DECODER INSTANCE
  zxing4p = new ZXING4P();

  // DISPLAY VERSION INFO
  zxing4p.version();

  // ADD SOME TEST PICTURES
  photos.add(loadImage("photo.jpg"));
  photos.add(loadImage("single_code.gif"));

  font = loadFont("ArialMT-14.vlw");
  textFont(font, 14);
  textAlign(CENTER);
} // setup()


/*****************************************************************************
 *
 *  DRAW
 *
 *****************************************************************************/
void draw() { 
  background(255);

  pushStyle();
  if (decodedText.equals("")) { 
    // DISPLAY PHOTO AND WAIT FOR KEY PRESS
    set(0, 0, photos.get(currentPhoto));
    fill(50);
    if (markers == null)
      txt = "Press the <SPACE>-bar to detect and decode the QRCode";
    else
      txt = "Press the <+>-key for the next image";

    txtWidth = int(textWidth(txt));
    fill(0, 150);
    rect((width - txtWidth)/2 - 6, height - 40, txtWidth + 12, 30);
    fill(255);
    text(txt, width>>1, height-20);

    // SHOW THE POSITION MARKERS (IF QR-CODE DETECTED)
    if (markers != null) {
      fill(255, 0, 0);
      stroke(255, 0, 0);
      rectMode(CENTER);
      for (int i=0; i<markers.length; i++) {
        int j = i + 1;
        if (j > 3) j = 0;
        line(markers[i].x, markers[i].y, markers[j].x, markers[j].y);
        if (!dumped) println("x: "+markers[i].x+" y: "+markers[i].y);
      }
      dumped = true;
    }
  } else { 
    // IMAGE FOUND AND HAS BEEN DECODED
    println("QRCode READS:\n\""+decodedText+"\"\n");
    decodedText = "";

    // GET THE MARKERS FOR THE DETECTED IMAGE
    markers = zxing4p.getPositionMarkers();
  } // if (decodedText.equals(""))
  popStyle();
} // draw()


/*****************************************************************************
 *
 *  KEYBOARD HANDLER
 *
 *****************************************************************************/
void keyPressed() { 
  if (key == '+' || key == '=') {
    currentPhoto++;
    if (currentPhoto >= photos.size()) currentPhoto = 0;
    markers = null;
    set(0, 0, photos.get(currentPhoto));
  } else if (key == ' ') {
    // TRY TO DETECT AND DECODE A QRCode IN PHOTO
    if (!decodedText.equals("")) {
      // RESET
      decodedText = "";
    } else {
      try {  
        // QRCodeReader(PImage img, boolean tryHarder)
        // tryHarder: false => fast detection (less accurate)
        //            true  => best detection (little slower)
        decodedText = zxing4p.QRCodeReader(photos.get(currentPhoto), false);
      } 
      catch (Exception e) {  
        println("Zxing4processing exception: "+e);
        decodedText = "";
      } // try
    } // if (!decodedText.equals(""))
  } // if (key == '+' || key == '=')
} // keyPressed()
