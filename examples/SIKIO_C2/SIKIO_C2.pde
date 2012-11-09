/* 
   SparkFun SIKIO - Circuit 2, Digital In & Analog In
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   In this example, you will learn how to use digtial and analog input on the IOIO. The inputs
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

//Import IOIO library
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

//We're going to use text in this example, so we need a font from the Processing library PFont
PFont font;

//String to keep track of the button value.
String s;

//Main setup function; this is run once and is generally used to initialize things. 
void setup() {

  //Pick a font - PFont.list()[0] is good because it will list the available fonts on our system 
  //as an array and just pick the first one.
  font = createFont(PFont.list()[0], 32);
  textFont(font);
  
  //Instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds.
  thread1 = new IOIOThread("thread1", 100);
  //Start our thread.
  thread1.start();
   
  //Drawing options.
  noStroke(); //disables the outline
  rectMode(CENTER); //place rectangles by their center coordinates
}

//Main draw loop is repeated 60 times a second.
void draw() {
  
  //Set background to black.
  background(0,0,0);
  
  //Set our fill to correspond to the value from our potentiometer (scale it up from 0-1 
  //to 0-255)
  fill(thread1.potVal * 255);
  //draw a sqaure with that fill slightly left of center
  rect(width/2-50, height/2, 100, 100); 
  
  //Now set our fill color to white or black, based on our button state.
  if(thread1.buttonVal == true) {
   //white is pressed 
   fill(255); //fill white
   s = "1";
  }
  else if(thread1.buttonVal == false) {
   //black is not pressed 
   fill(0); //fill black
   s = "0";
  }
  
  //Draw another square next to our first one showing the button state
  rect(width/2+50, height/2, 100, 100);
  
  //Put some text at the top displaying our potentionmeter and button values.
  fill(255);
  text(thread1.potVal, 10, 50); 
  text(s, 190, 50);
}
