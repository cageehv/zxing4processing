This library was created to integrate the open source ZXING barcode library with Processing.

By Rolf van Gelder :: http://rvg.cage.nl/ :: http://cagewebdev.com/ :: info@cagewebdev.com

Library page: http://cagewebdev.com/zxing4processing-processing-library/

v3.5 :: 07/29/2018
- New: decode 17 different types of barcodes (barcodeReader() method)
- Change: Most of the code has been rewritten
- decodeImage() changed to QRCodeReader()
- decodeMultipleQRCodes() changed to multipleQRCodeReader()

v3.4 :: 06/20/2018
- bug fixed for multiple codes position markers

v3.3 :: 04/14/2018
- Added Multi QRCode support
- New mothod: decodeMultipleQRCodes()
- New method: getPositionMarkers(i)

v3.2 :: 07/31/2016
- Removed deprecated method: 'decodeWeb()'
- Added a new method: 'version()'
- Several minor changes


v3.1 :: 07/21/2016
- Renamed the library to zxing4p3, a Processing 2.x/3.x compatible version
- New method: getPositionMarkers()
