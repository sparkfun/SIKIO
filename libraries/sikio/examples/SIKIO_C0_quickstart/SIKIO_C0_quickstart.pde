/* 
   SparkFun SIKIO - Quickstart
   Hardware Concept: Digital Out
   Android Concept: Draw Box 
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This is essentially a blink sketch intended to demonstrate the basics of programming an
   Android with the Processing development environment to interact with hardware via a IOIO.
   This example blinks an LED on the IOIO board and blinks a rectangle on the Android screen.
   This example shows how the main Processing file (in this case, SIKIO_C0_quickstart.pde)
   and the IOIO_Tab.pde file work and interact. The main .pde file controls the Android
   user interface and the IOIO_Tab.pde controls the IOIO board, and the two interact
   through the use of global variables, in this case the 'lightON' variable.
   
   HARDWARE:
   This is an example that doesn't require anything other than your Android and a IOIO,
   connected by a USB cable, and a way to power your IOIO through the JST connector.
   
   OPERATION:
   Connect your Android to the computer with a USB cable, and click the 'Run on Device' 
   button in the Processing IDE. Once Processing displays 'Sketch launched on the device'
   dialogue, connect your Android phone to your powered IOIO device with a USB cable.
   Every half second, the IOIO loop sends a command to the IOIO to turn the onboard
   LED on or off. It toggles the global variable 'lightON' at that time before going
   to back to sleep. This global variable is read within the main draw() loop and a black 
   or white box is drawn depending on the state of the LED.
*/

// Import the SIKIO libraries. If you want to interact with the IOIO board, you must 
// include all of these files. These come from the sikio folder in your Processing ->
// libraries directory.
import ioio.lib.spi.*;
import ioio.lib.api.*;
import ioio.lib.util.*;
import ioio.lib.util.android.*;
import ioio.lib.android.bluetooth.*;
import ioio.lib.impl.*;
import sikio.*;
import ioio.lib.android.accessory.*;
import ioio.lib.api.exception.*;

// This ia a global boolean variable to keep track of the LED on/off state. The variable can be
// used in this file or the IOIO_Tab. 
boolean lightOn = false;

// Main setup function; this is run once and is generally used for initialization. 
void setup() 
{
  // This creates and manages our IOIO object which allows us to interact with the IOIO hardware.
  new SikioManager(this).start();
  
  // Initialize drawing options.
  noStroke(); // Disables the outline around shapes
  rectMode(CENTER); // Place rectangles by their center coordinates, (the default is the TL corner)
  
  // Paint the background color.
  background(255,0,0); // background will be red, format:(R,G,B) 0-255
}

// Main draw loop is repeated 60 times a second. 
void draw() 
{
  //If LED is ON, draw a white rectangle.
  if (lightOn == true) 
  {
    fill(255); // Changes the fill color of future shapes we draw to white
  }
  //If LED is OFF, draw a black rectangle.
  else if (lightOn == false) 
  { 
    fill(0); // Changes the fill color of future shapes we draw to black
  }
  
  //The values of the horizontal and verticle resolutions of your display are found in the width
  //and height variables. Be sure to scale your objects as a ratio of width and height, so that 
  //if you use another size display, your objects won't be outside of the viewable area.    
  rect(width/2, height/2, 100, 100); // Draw a 100x100 pixel rectangle in the center of the screen
}
