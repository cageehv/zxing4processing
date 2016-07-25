# zxing4processing

Salvatore Iaconesi and Rolf van Gelder created a Processing Library called 'zxing4processing'.

Processing is an open source programming language and environment for people who want to create images, animations, and interactions.

The zxing4processing library is based on the open-source bar code library 'ZXing' http://code.google.com/p/zxing

Functionality

It can decode and generate QRCodes.

Available methods

    decode (boolean tryHarder, java.lang.String uri)
    Decode the image of the QRCode found at the passed URI

    decodePImage (boolean tryHarder, processing.core.PImage img)
    Decode the QRCode from a PImage object

    decodeWeb (boolean tryHarder, java.lang.String uri, java.net.URL codeBase)
    Decode the image of the QRCode found at the passed URL

    generateQRCode (java.lang.String content, int width, int height)
    Generates a QRCode image from a string

    getPositionMarkers ()
    Get the position markers for the latest detected QRCode (see the red lines in the image below)

History

v3.1 (07/21/2016): the first Processing v2.x/3.x compatible version

Download

Download the latest version (v3.1) of the library (for free, of course!):

zxing4p3.zip for Processing v2.x/3.x

Installation

Upzip the .zip file to your processing/libraries folder.

Examples

The in the .zip file included examples:

    decodeImageCam
    Hold a printed QRCode in front of your webcam and the sketch will automatically find it and decode it
    
    decodePImage
    Decode a QRCode straight from a Processing ‘PImage’ object
    
    generateQRCode
    Enter a text and it will generate a QRCode containing the text, with an option to save the generated image
