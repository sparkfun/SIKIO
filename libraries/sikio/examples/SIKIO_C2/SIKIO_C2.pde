/* 
   SparkFun SIKIO - Circuit 2, Digital In & Analog In
   Hardware Concept: Digital and Analog Input
   Android Concept: Displaying Text
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   In this example, you will learn how to use digital and analog input on the IOIO. The inputs
   will control the shading of two drawn boxes. The analog values are also printed to the screen.
   
   HARDWARE:
   -button
   -potentiometer
   -10kOhm resistor
   
   OPERATION: 
   A button is connected to pin 7 and a pot connected to pin 40. The app opens and
   two boxes are displayed with numbers above. Depending on the value of the pot, the left box
   will be shaded from white to black. The button simply changes the right most box from white 
   to black. A value between 0 and 1 will be displayed based on the pot and button values. 
 */

import ioio.lib.spi.*;
import ioio.lib.api.*;
import ioio.lib.util.*;
import ioio.lib.util.android.*;
import ioio.lib.android.bluetooth.*;
import ioio.lib.impl.*;
import sikio.*;
import ioio.lib.android.accessory.*;
import ioio.lib.api.exception.*;

// Create font for displaying text on screen.
PFont font;

// String to keep track of the button value.
String s;

void setup() 
{
  new SikioManager(this).start();

  // Use default font, size 32.
  font = createFont(PFont.list()[0], 32);
  textFont(font);
   
  // Drawing options
  noStroke(); // Disables the rectangles' outlines
  rectMode(CENTER); // Place rectangles by their center coordinates
}

void draw() 
{
  // The background can be used to clear the window at the beginning of each draw loop.
  background(0,0,0); // Set background to black.
  
  // Set our rectangles' fill color to correspond to the value of our potentiometer
  // Scale it up from 0-1 to 0-255
  fill(potVal * 255);
  
  // Draw a sqaure with that fill slightly left of center
  rect(width/2-50, height/2, 100, 100); 
  
  // Now set our fill color to white or black, based on our button state.
  if(buttonVal == true) 
  {
   // Button is pressed 
   fill(255); // Fill white
   s = "1";
  }
  else if(buttonVal == false) 
  {
   // Button is not pressed 
   fill(0); // Fill black
   s = "0";
  }
  
  // Draw another square next to our first one showing the button state
  rect(width/2+50, height/2, 100, 100);
  
  //Put some text at the top displaying our potentionmeter and button values.
  fill(255);
  text(potVal, 10, 50); 
  text(s, 190, 50);
}
