/*************************************************************************************
 *
 *	ZXing4P3: barcode library for Processing v2.x/3.x [v3.5, 07/29/2018]
 *
 *	http://cagewebdev.com/zxing4processing-processing-library/
 *
 *************************************************************************************/
package com.cage.zxing4p3;

// PROCESSING CORE CLASSES
import processing.core.PVector;
import processing.core.PImage;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/BarcodeFormat.html
import com.google.zxing.BarcodeFormat;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/DecodeHintType.html
import com.google.zxing.DecodeHintType;

import com.google.zxing.ReaderException;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/Result.html
import com.google.zxing.Result;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/ResultPoint.html
import com.google.zxing.ResultPoint;

import com.google.zxing.common.*;
import com.google.zxing.qrcode.*;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/QRCodeReader.html
import com.google.zxing.qrcode.QRCodeReader;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/decoder/Decoder.html
import com.google.zxing.qrcode.decoder.*;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/multi/qrcode/QRCodeMultiReader.html
import com.google.zxing.multi.qrcode.QRCodeMultiReader;

import com.google.zxing.BarcodeFormat.*;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/encoder/Encoder.html
import com.google.zxing.qrcode.encoder.*;

// NATIVE JAVA
import java.awt.Color;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.Hashtable;
import java.util.Vector;

/*************************************************************************************
 *
 *	This library was created to integrate the open source <a href="http://code.google.com/p/zxing/" target="_blank">ZXING barcode library</a> with
 *	Processing.<br><br>
 *
 *	By Rolf van Gelder ::
 *	<a href="http://rvg.cage.nl/" target="_blank">http://rvg.cage.nl/</a> ::
 *	<a href="http://cagewebdev.com/" target="_blank">http://cagewebdev.com/</a> ::
 *	<a href="mailto:info@cagewebdev.com">info@cagewebdev.com</a><br><br>
 *
 *	Library page:
 *	<a href="http://cagewebdev.com/zxing4processing-processing-library/" target="_blank">http://cagewebdev.com/zxing4processing-processing-library/</a><br><br>
 *
 *	v3.5 :: 07/29/2018<br>
 *  - New: decode 17 different types of barcodes (barcodeReader() method)<br>
 *	- Change: Most of the code has been rewritten<br>
 *	- decodeImage() changed to QRCodeReader()<br>
 *	- decodeMultipleQRCodes() changed to multipleQRCodeReader()<br>
 *<br> 
 *	v3.4 :: 06/20/2018<br>
 *  - bug fixed for multiple codes position markers<br> 
 *<br>
 *	v3.3 :: 04/14/2018<br>
 *	- Added Multi QRCode support<br>
 *	- New mothod: decodeMultipleQRCodes()<br>
 *	- New method: getPositionMarkers(i)<br>
 *<br>
 *	v3.2 :: 07/31/2016<br>
 *	- Removed deprecated method: 'decodeWeb()'<br>
 *	- Added a new method: 'version()'<br>
 *	- Several minor changes<br><br>
 *<br> 
 *	v3.1 :: 07/21/2016<br>
 *	- Renamed the library to zxing4p3, a Processing 2.x/3.x compatible version<br>
 *	- New method: getPositionMarkers()<br><br>
 *
 *	NOTE: Compiled with Java jdk1.6.0_45
 *
 *************************************************************************************/
 
public class ZXING4P {
	/*********************************************************************************
	 *
	 *	Properties
	 *
	 *********************************************************************************/
	String thisVersion     = "3.5";
	String thisReleaseDate = "07/29/2016";
	
	Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>(3);
	
	// RESULT OBJECT
	Result theResult;
	ResultPoint[] resultPoints;
	
	String theBarcodeFormat = "";
	
	// RESULT STRING
	String resString = "";
	Vector<String> resVector = new Vector<String>();
	
	// POSITION MARKERS FOR THE QRCode
	PVector[] positionMarkers;
	
	// ARRAY LIST WITH THE POSITION MARKERS FOR MULTIPLE QR CODES
	ArrayList<PVector[]> alMarkersZxing4p = new ArrayList<PVector[]>();

	
	/*********************************************************************************
	 *
	 *	Constructor
	 *
	 *********************************************************************************/
	public ZXING4P() {
	} // ZXING4P()


	/*********************************************************************************
	 *
	 *	Decode the QRCode from a PImage
	 *
	 *	@param img			PImage containing the image to be examinded
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *
	 *	@return				String with the found QRCode (empty if nothing found)
	 *
	 *********************************************************************************/
	public String QRCodeReader(PImage img, boolean tryHarder) {
		// SCAN THE IMAGE
		return multiFormatReaderScan(img, tryHarder, "QRCodeReader");
	} // QRCodeReader()


	/*********************************************************************************
	 *
	 *	Decode the QRCode from a PImage - DEPRECATED, USE QRCodeReader INSTEAD
	 *
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *	@param img			PImage containing the image to be examinded
	 *
	 *	@return				String with the found QRCode (empty if nothing found)
	 *
	 *********************************************************************************/	
	public String decodeImage(boolean tryHarder, PImage img) {
		return multiFormatReaderScan(img, tryHarder, "QRCodeReader");
	} // decodeImage()
	

	/*********************************************************************************
	 *
	 *	Decode multiple QRCodes from a PImage
	 *
	 *	@param img			PImage containing the image to be examinded
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *
	 *	@return				String array with the found QRCode(s)
	 *						(null if nothing found)
	 *
	 *********************************************************************************/
	public String[] multipleQRCodeReader(PImage img, boolean tryHarder) {
		BufferedImage bufferedImage = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_ARGB);
		
		String[] resArr  = null;
		Result[] results = null;
		ArrayList<String> resList;

		for (int x = 0; x < img.width; x++)
			for (int y = 0; y < img.height; y++) bufferedImage.setRGB(x, y, img.get(x,y));

		if (tryHarder) hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);

		try {
			// LOAD THE IMAGE
			LuminanceSource lumiancesource = new BufferedImageLuminanceSource(bufferedImage);
			BinaryBitmap monoImg = new BinaryBitmap(new GlobalHistogramBinarizer(lumiancesource));
			
			// SCAN FOR QR CODES
			results = new QRCodeMultiReader().decodeMultiple(monoImg, hints);
			
			// NO QR CODES FOUND
			if(results.length < 1) {
				// System.out.println("No QR codes found"); v3.4
				return null;
			} // if(results.length < 1)
				
			resList = new ArrayList<String>();
				
			alMarkersZxing4p.clear();
				
			for (int i = 0; i < results.length; i++) {
				String s = results[i].getText();
				// PREVENT THE 'GLYPH NOT FOUND' MESSAGE
				s = s.replace("\r\n", "\n");
				resList.add(s);
				
				// UPDATE THE MARKERS			
				resultPoints = results[i].getResultPoints();
				PVector[] positionMarkers = new PVector[resultPoints.length];
			
				for(int r = 0; r < resultPoints.length; r++)
					positionMarkers[r] = new PVector (resultPoints[r].getX(), resultPoints[r].getY());

				alMarkersZxing4p.add(positionMarkers);
			} // for (int i = 0; i < results.length; i++)

			// ARRAYLIST TO SIMPLE ARRAY
			resArr = new String[resList.size()];
			resList.toArray(resArr);
		} catch (Exception e) {
			// No QRCode found...
			return null;
		} // try
		
		return resArr;
	} // multipleQRCodeReader()


	/*********************************************************************************
	 *
	 *	Decode multiple QRCodes from a PImage - DEPRECATED, USE multipleQRCodeReader
	 *	INSTEAD
	 *
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *	@param img			PImage containing the image to be examinded
	 *
	 *	@return				String array with the found QRCode(s)
	 *						(null if nothing found)
	 *
	 *********************************************************************************/	
	public String[] decodeMultipleQRCodes(boolean tryHarder, PImage img)
	{	// DEPRECATED - USE multipleQRCodeReader INSTEAD
		return multipleQRCodeReader(img, tryHarder);
	} // decodeMultipleQRCodes()	

	
	/*********************************************************************************
	 *
	 *	Get the format of the latest detected barcode
	 *
	 *	@return		format of the latest detected barcode
	 *
	 *********************************************************************************/
	public String getBarcodeFormat() {
		return theBarcodeFormat;
	} // getBarcodeFormat()
	
	
	/*********************************************************************************
	 *
	 *	Decode a barcode from a PImage (scan for all supported barcodes types)
	 *
	 *	@param img			PImage containing the image to be examinded
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *
	 *	@return				String with the found QRCode (empty if nothing found)
	 *
	 *********************************************************************************/
	public String barcodeReader(PImage img, boolean tryHarder) {
		// SCAN THE IMAGE FOR ALL SUPPORTED BARCODES
		return multiFormatReaderScan(img, tryHarder, "multiFormatReader");
	} // barcodeReader()
	

   /*********************************************************************************
	*
	*	Decode a barcode from a PImage (scan for specific barcode types)
	*
	*	@param img			PImage containing the image to be examinded
	*	@param tryHarder	if set to true, it tells the software to spend a little
	*						more time trying to decode the image
	*	@param barCodeTypes	barcode types to scan for
	*
	*	@return				String with the found barcode (empty if nothing found)
	*
	*	https://zxing.github.io/zxing/apidocs/com/google/zxing/BarcodeFormat.html
	*
	*	SUPPORTED BARCODE TYPES:
	*	AZTEC
	*	CODABAR
	*	CODE_128
	*	CODE_39
	*	CODE_93
	*	DATA_MATRIX
	*	EAN_13
	*	EAN_8
	*	ITF
	*	MAXICODE
	*	PDF_417
	*	QR_CODE
	*	RSS_14
	*	RSS_EXPANDED
	*	UPC_A
	*	UPC_E
	*	UPC_EAN_EXTENSION
	*
	*********************************************************************************/
	public String barcodeReader(PImage img, boolean tryHarder, ArrayList<String> barCodeTypes) {
		
		// PROCESS THE LIST WITH BARCODE TYPES
		EnumSet<BarcodeFormat> decodeFormats = EnumSet.noneOf(BarcodeFormat.class);

		for(int i = 0; i < barCodeTypes.size(); i++) {
			BarcodeFormat format = parseBarCodeString(barCodeTypes.get(i));
			if (format != null) {
				decodeFormats.add(format);
			} // if (format != null)
		} // for(int i = 0; i < barCodeTypes.size(); i++)

		// ADD TO HINTS
		hints.put(DecodeHintType.POSSIBLE_FORMATS, decodeFormats);
		
		// SCAN THE IMAGE
		return multiFormatReaderScan(img, tryHarder, "multiFormatReader");
	} // barcodeReader()

	
	/*********************************************************************************
	 *
	 *	Acually scan for barcodes
	 *
	 *	@param img			image to scan
	 *	@param tryHarder	if set to true, it tells the software to spend a little
	 *						more time trying to decode the image
	 *	@param reader		which reader to use
	 *
	 *	@return				String with the found barcode (empty if nothing found)
	 *
	 *********************************************************************************/
	private String multiFormatReaderScan(PImage img, boolean tryHarder, String reader) {

		resString = "";
		
		BufferedImage bufferedImage = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_ARGB);

		// CONSTRUCT THE IMAGE TO SCAN
		for (int x = 0; x < img.width; x++)
			for (int y = 0; y < img.height; y++) bufferedImage.setRGB(x,y,img.get(x,y));

		if (tryHarder) hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
		try {			
			LuminanceSource lumiancesource = new BufferedImageLuminanceSource(bufferedImage);
			BinaryBitmap monoImg = new BinaryBitmap(new GlobalHistogramBinarizer(lumiancesource));
			
			if(reader.equals("multiFormatReader")) {
				// DO THE SCAN
				theResult = new MultiFormatReader().decode(monoImg, hints);
			} else if(reader.equals("QRCodeReader")) {
				theResult = new QRCodeReader().decode(monoImg, hints);
			}
			
			// GET THE DECODED TEXT
			resString = theResult.getText();
			
			// GET THE FORMAT OF THE FOUND BARCODE
			theBarcodeFormat = theResult.getBarcodeFormat().toString();
			
			// PREVENT THE 'GLYPH NOT FOUND' MESSAGE
			resString = resString.replace("\r\n", "\n");

			// UPDATE THE MARKERS			
			resultPoints = theResult.getResultPoints();
			positionMarkers = new PVector[resultPoints.length];
			for(int i=0; i<resultPoints.length; i++)
				positionMarkers[i] = new PVector (resultPoints[i].getX(), resultPoints[i].getY());
			
		} catch (Exception e) {
			// NO QRCODE FOUND...
			return "";
		} // try
	
		return resString;		
	} // multiFormatReaderScan()
	

   /*********************************************************************************
	*
	*	Parse barcodes as BarcodeFormat constants
	*
	*	@param c	code to parse
	*
	*	@return		barcode format
	*
	*********************************************************************************/
	private BarcodeFormat parseBarCodeString(String c) {
		if (c.equals("AZTEC")) {
			return BarcodeFormat.AZTEC;
		} else if (c.equals("CODABAR")) {
			return BarcodeFormat.CODABAR;
		} else if (c.equals("CODE_128")) {
			return BarcodeFormat.CODE_128;
		} else if (c.equals("CODE_39")) {
			return BarcodeFormat.CODE_39;
		} else if (c.equals("CODE_93")) {
			return BarcodeFormat.CODE_93;
		} else if (c.equals("DATA_MATRIX")) {
			return BarcodeFormat.DATA_MATRIX;			
		} else if (c.equals("EAN_13")) {
			return BarcodeFormat.EAN_13;
		} else if (c.equals("EAN_8")) {
			return BarcodeFormat.EAN_8;
		} else if (c.equals("ITF")) {
			return BarcodeFormat.ITF;		
		} else if (c.equals("MAXICODE")) {
			return BarcodeFormat.MAXICODE;
		} else if (c.equals("PDF_417")) {
			return BarcodeFormat.PDF_417;			
		} else if (c.equals("QR_CODE")) {
			return BarcodeFormat.QR_CODE;
		} else if (c.equals("RSS_14")) {
			return BarcodeFormat.RSS_14;
		} else if (c.equals("RSS_EXPANDED")) {
			return BarcodeFormat.RSS_EXPANDED;
		} else if (c.equals("UPC_A")) {
			return BarcodeFormat.UPC_A;			
		} else if (c.equals("UPC_E")) {
			return BarcodeFormat.UPC_E;
		} else if (c.equals("UPC_EAN_EXTENSION")) {
			return BarcodeFormat.UPC_EAN_EXTENSION;
		} else {
			return null;
		}
	} // parseBarCodeString()

	
	/*********************************************************************************
	 *
	 *	Generates a QRCode PImage from a string
	 *
	 *	@param content	string to encode
	 *	@param width	width of the PImage that will be returned
	 *	@param height	height of the PImage that will be returned
	 *
	 *	@return			PImage with the QRCode image
	 *
	 *********************************************************************************/
	public PImage generateQRCode(String content, int width, int height) {
		PImage pImage = new PImage(width, height);

		QRCodeWriter encoder = new QRCodeWriter();

		try {
			BitMatrix bitMatrix = encoder.encode(content, BarcodeFormat.QR_CODE, width, height);
			
			// COPY THE BYTEMATRIX TO THE PIMAGE
			for(int i=0; i<width; i++)
				for(int j=0; j<height; j++) {
					int colorValue = 0; // BLACK
					if(!bitMatrix.get(j, i)) colorValue = 16777215;	// WHITE
					// ADD THE PIXEL TO THE IMAGE
					pImage.set(i, j, colorValue);
				} // for(int j=0; j<height; j++)
		} catch ( Exception e ) {
			System.out.println("Error generating QRCode image (PImage generateQRCode) " + e);
		} // try
		
		return pImage;
	} // PImage generateQRCode()
	
	
	/*********************************************************************************
	 *
	 *	Returns a PVector array with the position markers for the latest detected QRCode
	 *
	 *	@return	PVector with the position markers for the latest detected QRCode
	 *
	 *********************************************************************************/
	public PVector[] getPositionMarkers() {
		return positionMarkers;
	} // getPositionMarkers()


	/*********************************************************************************
	 *
	 *	Returns a PVector array with the position markers for a specific QRCode
	 *
	 *	@param index	index of the detected QRCode
	 *
	 *	@return	PVector with the position markers for the detected QRCode
	 *
	 *********************************************************************************/
	public PVector[] getPositionMarkers(int index) {
		return alMarkersZxing4p.get(index);
	} // getPositionMarkers()

	
	/*********************************************************************************
	 *
	 *	Displays version information of this library in the console
	 *
	 *********************************************************************************/
	public void version() {
		System.out.println("Zxing4processing v"+thisVersion+" ("+thisReleaseDate+"), by Rolf van Gelder (cagewebdev.com)\n");
	} // void version()	
} // ZXING4P
