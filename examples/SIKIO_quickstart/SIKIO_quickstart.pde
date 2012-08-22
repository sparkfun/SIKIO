/* Quickstart circuit code for SIKIO
 * Blinks the STAT Led on the IOIO - good for making sure everything is hooked up properly
 * by Ben Leduc-Mills
 */

//Import IOIO library - this is from the link in the install section of your SIKIO guide
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

//boolean to turn the light on or off
boolean lightOn = false;

//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

int rectSize = 100;

void setup() {

  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();

  size(480, 800); 
  
  smooth();
  noStroke();
  fill(0);
  rectMode(CENTER);     //This sets all rectangles to draw from the center point
}

void draw() {
  background(#FF9900);
  rect(width/2, height/2, rectSize, rectSize);


  //if light was on, turn it off and shrink the rectangle
  if (lightOn == true) {
    fill(0);
  }

  //if the light was off, turn it on, and make the rectangle bigger
  else if (lightOn == false) { 
    fill(255);
  }
}

