/* 
   SparkFun SIKIO - Quickstart 
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This example shows how the main Processing file and the IOIOThread.pde file interact. 
   
   HARDWARE:
   This is an example that doesn't require anything other than your Android and a IOIO.
   
   OPERATION:
   The sketch starts by running IOIOThread.pde. In the thread, a flag is set through the 
   variable 'lightON', when the LED turns on and off. This global variable is read in 
   the code below and a black or white box is drawn depending on the state of the LED.
 */

//Import IOIO the IOIO libraries.
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

//Create a IOIO instance.
IOIO ioio = IOIOFactory.create();

//Create a thread for our IOIO code. The thread code is found in IOIOThread.pde. The 
//thread runs independently of the main sketch below.
IOIOThread thread1; 

//This ia a boolean variable that reads if the LED is on or off. The variable can be
//used in this file or the IOIOThread.pde file. 
boolean lightOn = false;

//These global variables contain your display width and height and will be used to 
//scale objects that are drawn. We draw things based off of the disply size, because 
//the code will be able to work with different display resolutions. These variables
//need to be floats.
float displayW, displayH;

//Main setup function
void setup() {
  
  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();
  
  //Lock screen in portrait mode.
  orientation(PORTRAIT);
  
  //Set the size of the display to be your screen size. These variables are defined from the
  //size() function in Processing
  displayW = displayWidth;
  displayH = displayHeight; 
  
  //Drawing options.
  smooth(); //anti-aliased edges
  noStroke(); //disables the outline
  rectMode(CENTER); //sets all rectangles to draw from the center point
  
  //Paint background color.
  background(255,0,0);//red
}

//Main draw loop. 
void draw() {
  //If LED is ON, draw a black rectangle.
  if (lightOn == true) {
    fill(0); //draw black
    rect(displayW/2, displayH/2, 100, 100);
  }
  //If LED is OFF, draw a white rectangle.
  else if (lightOn == false) { 
    fill(255); //draw white
    rect(displayW/2, displayH/2, 100, 100);
  }
}
