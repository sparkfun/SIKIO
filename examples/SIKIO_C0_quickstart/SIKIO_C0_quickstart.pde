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
   and the IOIOThread.pde file work and interact. The main .pde file controls the Android
   user interface and the IOIOThread.pde controls the IOIO board, and the two interact
   through the use of global variables, in this case the 'lightON' variable.
   
   HARDWARE:
   This is an example that doesn't require anything other than your Android and a IOIO,
   connected by a USB cable, and a way to power your IOIO through the JST connector.
   
   OPERATION:
   Connect your android to the computer with a USB cable, and click the 'Run on Device' 
   button in the Processing IDE. Once Processing displays 'Sketch launched on the device'
   dialogue, connect your Android phone to your powered IOIO device with a USB cable.
   Every half second, the IOIO Thread sends a command to the IOIO to turn the onboard
   LED on or off. It also sets the global variable 'lightON' at that time before going
   to back to sleep. The draw loop in the main processing code (code below), 
   The sketch starts by running IOIOThread.pde. In the thread, a flag is set through the 
   global variable 'lightON', when the LED turns on and off. This global variable is read in 
   the code below and a black or white box is drawn depending on the state of the LED.
*/

//Import the IOIO libraries. If you want to interact with the IOIO board, you must 
//include all of these files. These come from the IOIO folder in your Processing ->
//libraries directory.
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

//Create a IOIO object. This allows easy control of the IOIO through the IOIO API. 
//In this example, it allows for controlling a digital pin and the attached on-board LED.
IOIO ioio = IOIOFactory.create();

//Create an instance of our IOIOThread class. The thread code is found in IOIOThread.pde. The 
//thread runs independently of the main sketch below.
IOIOThread thread1; 

//This ia a global boolean variable to keep track of the LED on/off state. The variable can be
//used in this file or the IOIOThread.pde file. 
boolean lightOn = false;

//Main setup function; this is run once and is generally used to initialize things. 
void setup() {
  
  //Instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds.
  //The wait time is the time in between interations of the thread.  
  thread1 = new IOIOThread("thread1", 100);
  //Start our thread.
  thread1.start();
  
  //Initialize drawing options.
  noStroke(); //disables the outline around shapes
  rectMode(CENTER); //place rectangles by their center coordinates, (the default is the TL corner)
  
  //Paint the background color.
  background(255,0,0);//red, format:(R,G,B)
}

//Main draw loop is repeated 60 times a second. 
void draw() {

  //If LED is ON, draw a black rectangle.
  if (lightOn == true) {
    fill(0); //changes the fill color of future shapes we draw to black
    //The values of the horizontal and verticle resolutions of your display are found in the width
    //and height variables. Be sure to scale your objects as a ratio of width and height, so that 
    //if you use another size display, your objects won't be outside of the viewable area.    
    rect(width/2, height/2, 100, 100); //draw a 100x100 pixel rectangle in the center of the screen
  }
  //If LED is OFF, draw a white rectangle.
  else if (lightOn == false) { 
    fill(255); //draw white
    rect(width/2, height/2, 100, 100); //draw rectangle
  }
}
