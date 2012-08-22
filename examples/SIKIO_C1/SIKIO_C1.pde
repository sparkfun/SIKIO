/* SIKIO Circuit 1 - Digital Out & Intro to APWidgets
 * by Ben Leduc-Mills
 * Uses the APWidgets library to make several buttons that control an RGB Led
 * Pin 4 = Red, Pin 5 = Green, Pin 6 = Blue
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

//make a widget container and 3 buttons, one for each color
APWidgetContainer widgetContainer; 
APButton redButton;
APButton greenButton;
APButton blueButton;


//our rectangle size
int rectSize = 100;

//boolean to turn the light on or off
boolean lightOn = false;

boolean redOn, greenOn, blueOn = false;

//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

void setup() {

  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();

  size(480, 800); 
  smooth();
  noStroke();
  fill(255);
  rectMode(CENTER);     //This sets all rectangles to draw from the center point

  //create new container for widgets
  widgetContainer = new APWidgetContainer(this); 

  //create new button from x- and y-pos. and label. size determined by text content
  redButton = new APButton(10, 10, "Red"); 
  greenButton = new APButton(70, 10, "Green");
  blueButton = new APButton(150, 10, "Blue"); 

  //place buttons in container
  widgetContainer.addWidget(redButton);
  widgetContainer.addWidget(greenButton);
  widgetContainer.addWidget(blueButton);
}

void draw() {
  background(#FF9900);
}


//onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {

  //each button toggles the boolean associated with that button's led color
  //in the ioio thread, we switch the LED on or off based on the status of that boolean
  
  if (widget == redButton) { 
      redOn = !redOn;
  }
  
  if(widget == greenButton) {
    greenOn = !greenOn; 
  }
  
  if(widget == blueButton) {
    blueOn = !blueOn;
  }
}

