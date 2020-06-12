/*****************************************************************************
 *
 *  INPUT HANDLERS
 *
 *****************************************************************************/


/*****************************************************************************
 *
 *  KEYBOARD HANDLER
 *
 *****************************************************************************/
void keyPressed() {
  switch (key) {
  case 'c':
  case 'C':
    useCam = !useCam;
    break;

  case 'm':
  case 'M':
    showMarkers = !showMarkers;
    break;

  case 't':
  case 'T':
    showText = !showText;
    break;
  } // switch
} // keyPressed()


/*****************************************************************************
 *
 *  MOUSE HANDLER
 *
 *****************************************************************************/
void mouseReleased() {
  cursor(ARROW);
} // mouseReleased()


void mouseDragged() {
  cursor(HAND);
  for (int i= 0; i < qrcodes.size(); i++) {
    if (qrcodes.get(i).mouseOver()) {
      if (mouseX > pmouseX) {
        qrcodes.get(i).x = qrcodes.get(i).x + (mouseX - pmouseX);
      } else {
        qrcodes.get(i).x = qrcodes.get(i).x - (pmouseX - mouseX);
      } // if (mouseX > pmouseX)
      if (mouseY > pmouseY) {
        qrcodes.get(i).y = qrcodes.get(i).y + (mouseY - pmouseY);
      } else {
        qrcodes.get(i).y = qrcodes.get(i).y - (pmouseY - mouseY);
      } // if (mouseY > pmouseY)
    } // if (qrcodes.get(i).mouseOver())
  } // for (int i= 0; i < qrcodes.size(); i++)
} // void mouseDragged()
