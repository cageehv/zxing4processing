/**
 *
 *	ZXing4P3: barcode library for Processing 2/3 [07/21/2016]
 *
 **/
package com.cage.zxing4p3;

import processing.core.PVector;
import processing.core.PImage;

// https://zxing.github.io/zxing/apidocs/com/google/zxing/BarcodeFormat.html
import com.google.zxing.BarcodeFormat;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/DecodeHintType.html
import com.google.zxing.DecodeHintType;
import com.google.zxing.MonochromeBitmapSource;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/MultiFormatReader.html
import com.google.zxing.MultiFormatReader;
import com.google.zxing.ReaderException;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/Result.html
import com.google.zxing.Result;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/ResultPoint.html
import com.google.zxing.ResultPoint;
import com.google.zxing.client.j2se.BufferedImageMonochromeBitmapSource;
import com.google.zxing.common.*;
import com.google.zxing.qrcode.*;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/QRCodeReader.html
import com.google.zxing.qrcode.QRCodeReader;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/decoder/Decoder.html
import com.google.zxing.qrcode.decoder.*;
// https://zxing.github.io/zxing/apidocs/com/google/zxing/qrcode/encoder/Encoder.html
import com.google.zxing.qrcode.encoder.*;

import java.awt.Color;
import java.awt.Image;
import java.awt.image.BufferedImage;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.net.*;

import java.util.Hashtable;
import java.util.Vector;

import javax.imageio.ImageIO;

/**
 * This library was created to integrate into processing (v2.x/3.x) the wonderful barcode decoding library
 * called ZXING that you can find n google code here<br>
 * <a href="http://code.google.com/p/zxing/" target="_blank">http://code.google.com/p/zxing/</a><br><br>
 *
 * So no big deal was created by me, apart from the integration process. Which is also very limited in scope.<br><br>
 *
 * That's why I am releasing this code with no licensing whatsoever. Do what you want with it, but please respect the
 * licensing of the ZXINg libraries: you can find it in their software distribution packages. Please read it all up.<br><br>
 *
 * As for this small library: feel free and encouraged to make it better and more functional.<br><br>
 *
 * And please send me a note if you do something with it, as I'd love to see it and publish it over at Art is Open Source.<br><br>
 *
 * Best, xDxD.vs.xDxD@gmail.com<br>
 * <a href="http://www.artisopensource.net" target="_blank">http://www.artisopensource.net</a><br><br>
 *
 * Rolf van Gelder :: <a href="http://rvg.cage.nl/" target="_blank">http://rvg.cage.nl/</a> :: <a href="http://cagewebdev.com/" target="_blank">http://cagewebdev.com/</a><br>
 *
 * v3.1	07/21/2016 - Renamed the library to zxing4p3, a Processing 2.x / 3.x compatible version<br>
 *                 - New method: getPositionMarkers()
 *
 * Compiled with Java 1.6.0_45 (because of Processing 2.x compatibility)
 *
 */
 
public class ZXING4P {
	/**
	 * Properties
	 */
	String thisVersion = "3.1";
	String thisReleaseDate = "07/21/2016";
	
	Hashtable<DecodeHintType, Object> hints;
	
	Result theResult;
	ResultPoint[] resultPoints;
	
	String resString = "";
	Vector<String> resVector = new Vector<String>();
	
	// POSITION MARKERS FOR THE QRCode
	PVector[] positionMarkers;
	
	/**
	 * Constructor: instantiate the class in procesing's standard way: pass "this" as a parameter, when instantiating in a Processing applet
	 */
	public ZXING4P() {
		hints = new Hashtable<DecodeHintType, Object>(3);
		System.out.println("ZXing4P3 v"+thisVersion+" :: Rolf van Gelder :: cagewebdev.com\n");
	} // ZXING4P()

	
	/**
	 * Returns a PVector array with the position markers for the detected QRCode
	 * @return				PVector with the position markers for the detected QRCode
	 */	
	public PVector[] getPositionMarkers()
	{
		return positionMarkers;
	} // PVector[] getPositionMarkers()

	
	/**
	 * Generates a QRCode image from a string (added by: Rolf van Gelder)
	 * @param content 		string to encode
	 * @param width			width of the PImage that will be returned
	 * @param height		height of the PImage that will be returned
	 * @return				PImage with the QRCode image
	 */
	public PImage generateQRCode(String content, int width, int height)
	{
		PImage myPImage = new PImage(width,height);

		QRCodeWriter myWriter;
		myWriter = new QRCodeWriter();

		ByteMatrix myByteMatrix = null;

		Byte myPixel;

		int myColor;

		try {
			myByteMatrix = myWriter.encode(content, BarcodeFormat.QR_CODE, width, height);

			// COPY THE BYTEMATRIX TO THE PIMAGE
			for(int i=0; i<width; i++)
				for(int j=0; j<height; j++)
				{ 
					myPixel = myByteMatrix.get(j,i);
					myColor = 0; // BLACK
					if(myPixel!=0) myColor = 16777215;	// WHITE
					myPImage.set(i,j,myColor);
				} // for(int j=0; j<height; j++)
		}
		catch ( Exception e )
		{
			System.out.println("Error generating QRCode image (PImage generateQRCode)");
		}
		
		return myPImage;
	} // PImage generateQRCode()

	
	/**
	 * Decode the QRCode from a PImage (added by: Rolf van Gelder)
	 * @param tryHarder		if set to true, it tells the software to spend a little more time trying to decode the image
	 * @param img			PImage containing the image to be examinded
	 * @return				String with the found QRCode (empty if nothing found)
	 */
	public String decodeImage(boolean tryHarder, PImage img)
	{
		Decoder decoder = new Decoder();
		
		BufferedImage source = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_ARGB);

		for (int x = 0; x < img.width; x++)
			for (int y = 0; y < img.height; y++) source.setRGB(x,y,img.get(x,y));
	
		if (tryHarder) hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);

		try
		{
			MonochromeBitmapSource monoImg = new BufferedImageMonochromeBitmapSource(source);
			theResult = new QRCodeReader().decode(monoImg, hints);
			// System.out.println(theResult.getText());
			
			resString = theResult.getText();
			// System.out.println("Detected:\nformat   = "+theResult.getBarcodeFormat());
			// System.out.println("position = "+theResult.getResultPoints()[0].getX()+", "+theResult.getResultPoints()[0].getY());
			
			// PREVENT THE GLYPH NOT FOUND MESSAGE
			resString = resString.replace("\r\n", "\n");

			// UPDATE THE MARKERS			
			resultPoints = theResult.getResultPoints();
			positionMarkers = new PVector[resultPoints.length];
			for(int i=0; i<resultPoints.length; i++)
				positionMarkers[i] = new PVector (resultPoints[i].getX(), resultPoints[i].getY());
		} catch (ReaderException e)
		{
			// System.out.println("No QRCode found...");
		}
		
		return resString;
	} // String decodeImage()

	
	/**
	 * Decode the image of the QRCode found at the passed uri
	 * @param tryHarder		if set to true, it tells the software to spend a little more time trying to decode the image
	 * @param uri			the String contains the URI of the image conaining the QRCode to decode
	 * @return				a Vector containing the Strings found in the QRCode, or an empty Vector if nothing was decoded
	 */
	public Vector decode(boolean tryHarder, String uri) throws Exception
	{
		String s;
		
		if (tryHarder) hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);

		File inputFile = new File(uri);

		if (inputFile.exists())
		{
			if (inputFile.isDirectory())
			{
				int successful = 0;
				int total = 0;
				for (File input : inputFile.listFiles())
				{
					String filename = input.getName().toLowerCase();
					// SKIP HIDDEN FILES AND TEXT FILES (THE LATTER IS FOUND IN THE BLACKBOX TESTS).
					if (filename.startsWith(".") || filename.endsWith(".txt")) continue;
					
					try
					{
						s = decode(input.toURI(), hints);
					}
					catch ( Exception e )
					{
						System.out.println("Error decoding QRCode image (Vector decode 1)");
						s = null;
					}			  

					if (s != null && !s.trim().equals(""))
					{
						successful++;
						resVector.addElement(s);
					}
					
					total++;
					
				} // for (File input : inputFile.listFiles())
				
				// System.out.println("\nDecoded " + successful + " files out of " + total +
				//    " successfully (" + (successful * 100 / total) + "%)\n");
			}
			else
			{
				try
				{
					resVector.addElement(decode(inputFile.toURI(), hints));
				}
				catch (Exception e)
				{
					System.out.println("Error decoding QRCode image (Vector decode 2)");
				}					
			} // if (inputFile.isDirectory())
			
		}
		else
		{
			try
			{
				resVector.addElement(decode(new URI(uri), hints));
			}
			catch ( Exception e )
			{
				System.out.println("Error decoding QRCode image (Vector decode 3)");
			}			
		} // if (inputFile.exists())
		
		return resVector;
	} // Vector decode()

	
	/**
	 * Decode the image of the QRCode found at the passed uri. This version of the method can be used inside an Applet.
	 * Remember that java applets can only read in the same domain on which is the web page containing them.
	 * @param tryHarder		if set to true, it tells the software to spend a little more time trying to decode the image
	 * @param uri			the String contains the URI of the image conaining the QRCode to decode
	 * @param codeBase		the codebase of the applet on which the program is running
	 * @return				a Vector containing the Strings found in the QRCode, or an empty Vector if nothing was decoded
	 */
	public Vector decodeWeb(boolean tryHarder, String uri, URL codeBase) throws Exception
	{
		if (tryHarder) hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
		
		try
		{
			resVector.addElement(decodeWeb(uri, hints, codeBase));
		}
		catch (Exception e)
		{
			System.out.println("Error decoding QRCode image (Vector decodeWeb)");
		}

		return resVector;
	} // Vector decodeWeb()
 
 
	private String decode(URI uri, Hashtable<DecodeHintType, Object> hints) throws IOException
	{
		BufferedImage image;
		
		try {
		  image = ImageIO.read(uri.toURL());
		} catch (IllegalArgumentException iae) {
		  throw new FileNotFoundException("Resource not found: " + uri);
		}
		
		if (image == null) {
		  System.out.println(uri.toString() + ": Could not load image");
		  return "";
		}
		
		try {
		  MonochromeBitmapSource source = new BufferedImageMonochromeBitmapSource(image);
		  Result result = new MultiFormatReader().decode(source, hints);
		  // System.out.println(uri.toString() + " (format: " + result.getBarcodeFormat() + "):\n" + result.getText());
		  // System.out.println(result.getText());
		  resString = result.getText();
		  return resString;
		} catch (ReaderException e) {
		  // System.out.println(uri.toString() + ": No QRCode found (RvG)");
		  return "";
		}
		
	} // Vector decodeWeb()
  
  
	private String decodeWeb(String uri, Hashtable<DecodeHintType, Object> hints, URL codeBase) throws IOException
	{	
		BufferedImage image = null;
		
		try
		{
			URL url = new URL(codeBase, uri);
			image = ImageIO.read(url);
		} catch (IllegalArgumentException iae)
		{
			// throw new FileNotFoundException("Resource not found: " + uri);
			System.out.println(uri.toString() + ": Resource not found (RvG)");
		}
		
		if (image == null)
		{
			System.out.println(uri.toString() + ": Could not load image");
			return "";
		}
		
		try
		{
			MonochromeBitmapSource source = new BufferedImageMonochromeBitmapSource(image);
			Result result = new MultiFormatReader().decode(source, hints);
			// System.out.println(uri.toString() + " (format: " + result.getBarcodeFormat() + "):\n" + result.getText());
			resString = result.getText();
			return resString;
		}
		catch (ReaderException e)
		{
			System.out.println(uri.toString() + ": No QRCode found (RvG)");
			return "";
		}
		
	} // String decodeWeb()
} // public class ZXING4P