/*****************************************************************************
 *
 *  decodePImage - v07/21/2016
 * 
 *  A simple example of the use of the zxing.decodeImage() and
 *  zxing.getPositionMarkers() methods
 *
 *  Opens a photo and uses the zxing.decodeImage() method to find and decode
 *  QRCode images in that photo.
 *
 *  (c) 2013-2016 Rolf van Gelder http://cagewebdev.com/ :: http://rvg.cage.nl
 *
 *****************************************************************************/

// IMPORT THE zxing4p3 LIBRARY + DECLARE A ZXING4P OBJECT
import com.cage.zxing4p3.*;
ZXING4P zxing;

// THE POSITION MARKERS OF THE DETECTED QR-CODE IN THE IMAGE
PVector[] markers = null;

PFont  font;

ArrayList<PImage> photos = new ArrayList();
int currentPhoto = 0;

String decodedText = "";

boolean dumped = true;

/*****************************************************************************
 *  SETUP
 *****************************************************************************/
void setup()
{ 
  // CREATE A NEW EN-/DECODER INSTANCE
  zxing = new ZXING4P();

  photos.add(loadImage("photo.jpg"));
  photos.add(loadImage("multiple_codes.gif"));

  font = loadFont("ArialMT-14.vlw");
  textFont(font, 14);
  textAlign(CENTER);

  size(400, 400);
  surface.setSize(photos.get(currentPhoto).width, photos.get(currentPhoto).height);
} // setup()


/*****************************************************************************
 *  DRAW
 *****************************************************************************/
void draw()
{ 
  background(255);

  pushStyle();
  if (decodedText.equals(""))
  { 
    // DISPLAY PHOTO AND WAIT FOR KEY PRESS
    set(0, 0, photos.get(currentPhoto));
    fill(50);
    String txt = "Press the <SPACE>-bar to detect and decode the QRCode";
    int tw = int(textWidth(txt));
    fill(40);
    rect((width-tw)/2 - 6, height-40, tw + 12, 30);
    fill(255);
    text(txt, width>>1, height-20);

    // SHOW THE QR-CODE MARKERS (IF QR-CODE DETECTED)
    if (markers != null)
    {
      fill(255, 0, 0);
      stroke(255, 0, 0);
      rectMode(CENTER);
      for (int i=0; i<markers.length; i++)
      {  
        // rect(markers[i].x, markers[i].y, 10, 10);
        int j = i+1;
        if (j>3) j= 0;
        line(markers[i].x, markers[i].y, markers[j].x, markers[j].y);
        if (!dumped) println("x: "+markers[i].x+" y: "+markers[i].y);
      }
      dumped = true;
    }
  } else
  { 
    // IMAGE FOUND AND HAS BEEN DECODED
    println("QRCode READS:\n\""+decodedText+"\"\n");
    decodedText = "";

    // GET THE MARKERS FOR THE DETECTED IMAGE
    markers = zxing.getPositionMarkers();
  } // if (decodedText.equals(""))
  popStyle();
} // draw()


/*****************************************************************************
 *  KEYBOARD HANDLER
 *****************************************************************************/
void keyPressed()
{ 
  if (key == '+' || key == '=')
  {  
    currentPhoto++;
    if (currentPhoto >= photos.size()) currentPhoto = 0;
    // for (int i=0; i<4; i++) markers[i] = new PVector(-1, -1);
    markers = null;
    set(0, 0, photos.get(currentPhoto));
  } else if (key == ' ')
  {
    // TRY TO DETECT AND DECODE A QRCode IN PHOTO
    if (!decodedText.equals(""))
    {
      // RESET
      decodedText = "";
    } else
    {
      try
      {  
        // decodeImage(boolean tryHarder, PImage img)
        // tryHarder: false => fast detection (less accurate)
        //            true  => best detection (little slower)
        decodedText = zxing.decodeImage(true, photos.get(currentPhoto));
      }
      catch (Exception e)
      {  
        println("Exception: "+e);
        decodedText = "";
      }
    }
  }
} // keyPressed()