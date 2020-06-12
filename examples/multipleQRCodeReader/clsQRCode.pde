class QRCode {
  int       x, y;
  int       w, h;
  int       id;
  PImage    img;

  /***************************************************************************
   *
   *  CONSTRUCTOR
   *
   ***************************************************************************/
  QRCode(String _fn, int _x, int _y, int _id) {
    img = loadImage(_fn);
    x   = _x;
    y   = _y;
    w   = img.width;
    h   = img.height;
    id  = _id;
  } // QRCode()


  /***************************************************************************
   *
   *  SHOW THE DECODED TEXT
   *
   ***************************************************************************/
  void showText(String txt) {
    if (txt.equals("")) return;
    pushStyle();
    fill(0);
    textSize(12);
    text((id + 1) + ". " + txt, x + 5, y + 14);
    popStyle();
  } // void showText()


  /***************************************************************************
   *
   *  IS THE MOUSE OVER THIS QR-CODE?
   *
   ***************************************************************************/
  boolean mouseOver() {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
  } // mouseOver()
} // QRCode
