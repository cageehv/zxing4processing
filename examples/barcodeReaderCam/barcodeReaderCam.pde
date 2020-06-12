/*****************************************************************************
 *
 *  barcodeReaderCam - v08/17/2018
 *
 *  An example of the use of the ZXING4P.barcodeReader() method.
 *
 *  Opens a webcam and tries to find barcodes in the image.
 *
 *  You can define for which barcode types it will scan.
 *  Per default it looks for all available types.
 *
 *  When a barcode is detected it will display the decoded text.
 *
 *  Run this sketch and hold a printed copy of a barcode in front of the cam.
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

// OPENCV - download from: https://github.com/atduskgreg/opencv-processing
import gab.opencv.*;
OpenCV opencv;

// PIMAGE WITH THE BARCODES TO DETECT
PImage scanArea;

// TEXT THAT WAS FOUND
String decodedText;
String latestDecodedText = "";

// FORMAT OF THE LATEST FOUND BARCODE
String barcodeFormat = "";

int    txtWidth;

// FOR THE VIEW FINDER AND SCAN AREA
int    frameWidth  = 350;
int    frameHeight = 350;
int    lineSize    = 40;

int    scanWidth;
int    scanHeight;

int    brightness = 50;
float  contrast   = 0.75;

// CORNERS OF THE VIEW FINDER
PVector ul, ur, ll, lr;

// LIST WITH BARCODE TYPES TO LOOK FOR
ArrayList<String> barcodeTypes = new ArrayList<String>();

final static int EXPIRATION_TIME = 5000;
int endTime = 0;

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

  // OPEMCV
  opencv = new OpenCV(this, width, height);

  // CREATE A NEW EN-/DECODER INSTANCE
  zxing4p = new ZXING4P();

  // DISPLAY VERSION INFORMATION
  zxing4p.version();

  // UPPER LEFT CORNER OF THE VIEW FINDER
  ul = new PVector((width - frameWidth) >> 1, (height - frameHeight) >> 1);
  // UPPER RIGHT CORNER OF THE VIEW FINDER
  ur = new PVector(ul.x + frameWidth, ul.y);
  // LOWER LEFT CORNER OF THE VIEW FINDER
  ll = new PVector(ul.x, ul.y + frameHeight);
  // LOWER RIGHT CORNER OF THE VIEW FINDER
  lr = new PVector(ur.x, ur.y + frameHeight);

  // AREA TO SCAN
  scanWidth  = height + 150;
  scanHeight = height + 150;
  scanArea   = createImage(scanWidth, scanHeight, RGB);

  // BARCODE TYPES THAT WILL BE SCANNED FOR
  // SUPPORTED BARCODE TYPES:
  // AZTEC
  // CODABAR
  // CODE_128
  // CODE_39
  // CODE_93
  // DATA_MATRIX
  // EAN_13
  // EAN_8
  // ITF
  // MAXICODE
  // PDF_417
  // QR_CODE
  // RSS_14
  // RSS_EXPANDED
  // UPC_A
  // UPC_E
  // UPC_EAN_EXTENSION  
  barcodeTypes.add("EAN_8");
  barcodeTypes.add("EAN_13");
  barcodeTypes.add("DATA_MATRIX");
  barcodeTypes.add("QR_CODE");
} // setup()


/*****************************************************************************
 *
 *  DRAW
 *
 *****************************************************************************/
void draw() { 
  background(0);

  // UPDATE CAPTURE
  if (video.available()) {
    video.read();
  }

  // DISPLAY VIDEO CAPTURE
  set(0, 0, video);

  if (frameCount % 5 == 0) {
    // COPY THE VIEW FINDER AREA TO THE SCAN AREA
    scanArea.copy(video, (int)ul.x, (int)ul.y, frameWidth, frameHeight, 0, 0, scanWidth, scanHeight);
    opencv.loadImage(scanArea);
    opencv.gray();
    opencv.brightness(brightness);
    opencv.contrast(contrast);
    scanArea = opencv.getOutput();
  }

  // DISPLAY VIEW FINDER
  pushStyle();
  noFill();
  strokeWeight(4);
  stroke(255, 0, 0);
  line(ul.x, ul.y, ul.x + lineSize, ul.y);
  line(ul.x, ul.y, ul.x, ul.y + lineSize);
  line(ur.x - lineSize, ur.y, ur.x, ur.y);
  line(ur.x, ur.y, ur.x, ur.y + lineSize);
  line(ll.x, ll.y, ll.x + lineSize, ll.y);
  line(ll.x, ll.y - lineSize, ll.x, ll.y);
  line(lr.x - lineSize, lr.y, lr.x, lr.y);
  line(lr.x, lr.y - lineSize, lr.x, lr.y);
  popStyle();

  // EXPIRED?
  if (millis() >= endTime) {
    decodedText       = "";
    latestDecodedText = "";
  }

  // TRY TO DETECT AND DECODE A QRCODE IN THE VIDEO CAPTURE
  // multiFormatReader(PImage img, boolean tryHarder)
  // multiFormatReader(PImage img, boolean tryHarder, ArrayList<String> barcodeTypes)
  // img: image to scan for barcodes
  // tryHarder: false => fast detection (less accurate)
  //            true  => best detection (little slower)
  // barcodeTypes: barcode types to scan for
  try {
    // SCAN FOR ALL AVAILABLE BARCODE TYPES
    //decodedText = zxing4p.barcodeReader(scanArea, false);

    // SCAN FOR SPECIFIC BARCODE TYPES
    decodedText   = zxing4p.barcodeReader(scanArea, false, barcodeTypes);

    // GET THE TYPE OF THE LAST SCANNED BARCODE
    barcodeFormat = zxing4p.getBarcodeFormat();
  } 
  catch (Exception e) {
    // NOT FOUND
    decodedText = "";
  } // try

  if (!decodedText.equals("")) {
    // FOUND A BARCODE!
    if (latestDecodedText.equals("") || (!latestDecodedText.equals(decodedText))) {
      endTime = millis() + EXPIRATION_TIME;
      println("Zxing4processing detected: " + decodedText + " (" + barcodeFormat + ")");
    }
    latestDecodedText = decodedText;
  } // if (!decodedText.equals(""))

  // DISPLAY LATEST DECODED TEXT AND FORMAT
  if (!latestDecodedText.equals("")) {
    pushStyle();
    txtWidth = int(textWidth(latestDecodedText + " (" + barcodeFormat + ")"));
    fill(0, 150);
    rect((width>>1) - (txtWidth>>1) - 5, 15, txtWidth + 10, 36);
    fill(255, 255, 0);
    text(latestDecodedText + " (" + barcodeFormat + ")", width>>1, 43);
    popStyle();
  } // if (!latestDecodedText.equals(""))
} // draw()


/*****************************************************************************
 *
 *  KEYBOARD HANDLER
 *
 *****************************************************************************/
void keyPressed() {
  switch(key) {
  case ' ':
    // RESET
    decodedText       = "";
    latestDecodedText = "";
    break;
  } // switch
} // keyPressed()
