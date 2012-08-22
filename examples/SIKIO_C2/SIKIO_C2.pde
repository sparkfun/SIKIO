/* SIKIO Circuit 2
 * by Ben Leduc-Mills
 * Digital In & Analog In
 * Reading from a button and a potentiometer
 * Potentiometer on Pin 40, Button on Pin 4
 */

// Import APWidgets library - download from: http://code.google.com/p/apwidgets/downloads/list
import apwidgets.*;

//Import IOIO library - this is from the link in the install section of your SIKIO guide
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;


//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

//We're going to use text in this example, so we need a font
PFont font;

//string to keep track of button value
String s;

void setup() {

  //pick a font - PFont.list()[0] is good because it will list the available fonts on our system as an array and just pick the first one
  font = createFont(PFont.list()[0], 32);
  textFont(font);
  
  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();
  
  size(480, 800); 
  smooth();
  noStroke();
  fill(255);
  rectMode(CENTER);     //This sets all rectangles to draw from the center point

  
}

void draw() {
  
  //Set background to black
  background(#000000);
  
  //Set our fill to correspond to the value from our potentiometer (scale it up from 0-1 to 0-255)
  fill(thread1.potVal * 255);
  //draw a sqaure with that fill slightly left of center
  rect(width/2-50, height/2, 100, 100); 
  
  //now set our fill color to white or black, based on our button state
  if(thread1.buttonVal == true) {
   //white is pressed 
   fill(255); 
   s = "1";
  }
  else if(thread1.buttonVal == false) {
   //black is not pressed 
   fill(0); 
   s = "0";
  }
  
  //draw another square next to our first one showing the button state
  rect(width/2+50, height/2, 100, 100);
  
  
  //put some text at the top displaying our potentionmeter and button values
  fill(255);
  text(thread1.potVal, 10, 50); 
  text(s, 190, 50);
  
  
}
