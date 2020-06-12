/*****************************************************************************
 *
 *  multipleQRCodeReader - v07/29/2018
 *
 *  An example of the use of the ZXING4P.multipleQRCodeReader() and
 *  ZXING4P.getPositionMarkers() methods.
 *
 *  There are two operation modes:
 *  - IMAGE
 *  - CAM
 *
 *  You can toggle between the two modes by pressing the <c>-key
 *
 *  IMAGE mode:
 *  You can move the QR-codes around using dragging and dropping them.
 *  The codes will be constantly detected and decoded in their new positions.
 *
 *  CAM mode:
 *  It opens and displays the cam capture.
 *  Just hold one or more QR codes in front of the cam and the code(s) will be
 *  detected and decoded.
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

// FOR COMPARING ARRAYS
import java.util.Arrays;

// THE QR CODES
ArrayList<QRCode> qrcodes = new ArrayList<QRCode>();

ArrayList<PVector[]> allMarkers = new ArrayList<PVector[]>();

String detectedCodes[]    = null;
String detectedCodesOld[] = null;

PVector[] camMarkers;

PGraphics pg;

boolean useCam      = false;
boolean showMarkers = true;
boolean showText    = true;
boolean debug       = false;


/*****************************************************************************
 *
 *  SETUP
 *
 *****************************************************************************/
void setup() {
  size(640, 480);

  // CREATE QR-CODES (for IMAGE mode)
  qrcodes.add(new QRCode("qr1.png", 10, 10, 0));
  qrcodes.add(new QRCode("qr2.png", 400, 240, 1));
  qrcodes.add(new QRCode("qr3.png", 200, 300, 2));

  pg  = createGraphics(width, height);

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

  if (useCam) {
    // UPDATE CAPTURE
    if (video.available()) video.read();
    pg.beginDraw();
    pg.clear();
    pg.image(video, 0, 0);
    pg.endDraw();
  } else {
    // SHOW TWO QR CODES
    pg.beginDraw();
    pg.clear();
    for (int i = 0; i < qrcodes.size(); i++) {
      pg.image(qrcodes.get(i).img, qrcodes.get(i).x, qrcodes.get(i).y);
    }
    pg.endDraw();
  } // if (useCam)

  // SHOW IMAGE
  image(pg, 0, 0);

  // TRY TO DETECT AND DECODE A QRCODE IN THE VIDEO CAPTURE
  // decodeImage(boolean tryHarder, PImage img)
  // tryHarder: false => fast detection (less accurate)
  //            true  => best detection (little slower)
  try {  
    detectedCodes = zxing4p.multipleQRCodeReader(pg, false);

    if (detectedCodes.length > 0) {
      // QR-CODES DETECTED
      if (debug) {
        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
          // DIFFERENT CODES DETECTED
          println("\nNumber of QR Code(s) detected: " + detectedCodes.length);
        } // if (!Arrays.equals(detectedCodes, detectedCodesOld))
      }
    }

    // CLEAN UP
    allMarkers.clear();

    for (int i = 0; i < detectedCodes.length; i++) {
      allMarkers.add(zxing4p.getPositionMarkers(i));
    }

    if (debug) {
      for (int i = 0; i < detectedCodes.length; i++) {
        if (!Arrays.equals(detectedCodes, detectedCodesOld)) {
          println((i + 1) + ". " + detectedCodes[i]);
        } // if (!Arrays.equals(decodedArr, decodedArrOld))
      } // for (int i = 0; i < detectedCodes.length; i++)
    } // if (decodedArr.length > 0)

    // DISPLAY MARKERS AND DECODED TEXT
    if (useCam) {
      if (showMarkers) {
        for (int i = 0; i < allMarkers.size(); i++) {
          camMarkers = allMarkers.get(i);
          showMarkers(camMarkers);
        } // for (int i = 0; i < allCamMarkers.size(); i++)
      } // if (showMarkers)
    } else {
      for (int i = 0; i < qrcodes.size(); i++) {
        if (showText) qrcodes.get(i).showText(detectedCodes[i]);      
        if (showMarkers) {
          camMarkers = allMarkers.get(i);
          showMarkers(camMarkers);
        }
      } // for (int i = 0; i < qrcodes.size(); i++)
    } // if (useCam)
    detectedCodesOld = detectedCodes;
  }
  catch (Exception e) {
  } // try

  // SHOW LIST OF DETECTED CODES
  if (useCam && detectedCodes != null) {
    int x = 10;
    int y = 30;
    pushStyle();
    textSize(18);
    fill(0, 255, 0);
    for (int i = 0; i < detectedCodes.length; i++) {
      text(i + ". " + detectedCodes[i], x, y);
      y += 20;
    }
    popStyle();
  }
} // draw()


/*****************************************************************************
 *
 *  SHOW THE MARKERS FOR ONE QR-CODE
 *
 *****************************************************************************/
void showMarkers(PVector[] markers) {
  int j;
  pushStyle();
  fill(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(2);
  rectMode(CENTER);

  for (int p = 0; p < markers.length; p++) {
    j = p + 1;
    if (j > 3) j = 0;
    line(markers[p].x, markers[p].y, markers[j].x, markers[j].y);
  } // for (int i = 0; i < pvArr.length; i++)
  popStyle();
} // showMarkers()
