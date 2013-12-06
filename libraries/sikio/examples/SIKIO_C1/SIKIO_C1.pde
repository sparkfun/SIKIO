/* 
   SparkFun SIKIO - Circuit 1
   Hardware Concept: Digital Out
   Android Concept: Buttons
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This example shows how to control a tri-color LED with 3 on screen buttons.  
   
   HARDWARE:
   -Tri-color LED
   -3 330Ohm resistors
   
   OPERATION:
   In this example, your app will have three buttons that control ON/OFF for each color 
   of the tri-color LED and the color of the background. Pin 3 on the IOIO is connected 
   to the red LED, Pin 2 is connected to green, and Pin 1 is connected to blue. These are
   defined in the IOIO_Thread_C1.
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

// Library required for creating on screen buttons
import apwidgets.*;

// Make a widget container, necessary for holding the buttons.
APWidgetContainer widgetContainer;
// Declare 3 buttons, one for each color.
APButton redButton;
APButton greenButton;
APButton blueButton;

// Create boolean variables that will keep track of each color's status.
boolean redOn, greenOn, blueOn = false;

// Create variables to keep track of color for screen background.
int redVal, greenVal, blueVal = 0;

// Create font for displaying text on screen.
PFont font;

void setup() 
{
  new SikioManager(this).start();
  
  background(0, 0, 0); // Draw black background

  // Use default font, size 32.
  font = createFont(PFont.list()[0], 32);
  textFont(font);

  // Initialize widget container
  widgetContainer = new APWidgetContainer(this); 

  // Initialize buttons at x,y position with a label. Size determined by the label's content.
  redButton = new APButton(10, 40, "Red"); // (x,y,label)
  greenButton = new APButton(70, 40, "Green");
  blueButton = new APButton(150, 40, "Blue");

  // Place buttons in container, necessary for detecting presses.
  widgetContainer.addWidget(redButton);
  widgetContainer.addWidget(greenButton);
  widgetContainer.addWidget(blueButton);
}

void draw() 
{
  // Show the values of each color on screen as text underneath the buttons.
  // 0 is off, 255 is on. Will correlate with background color.
  text(redVal, 10, 150);
  text(greenVal, 70, 150);
  text(blueVal, 150, 150);
}


// onClickWidget is called when a widget is clicked/touched, the buttons in this case.
void onClickWidget(APWidget widget) 
{
  // Each button toggles the boolean associated with that button's LED color.
  // In the ioio tab, we switch the LED on or off based on the status of that boolean.
  
  // First check which widget was clicked, check if it was the red button in this case.
  // If redOn is true, the background/LED will be red or red mixed with other colors that are on.
  if (widget == redButton) 
  { 
    redOn = !redOn;
    if (redOn == true) 
    { 
      redVal = 255;
    }
    if (redOn == false) 
    { 
      redVal = 0;
    }
  }

  if (widget == greenButton) 
  {
    greenOn = !greenOn;
    if (greenOn == true) 
    { 
      greenVal = 255;
    }
    if (greenOn == false) 
    { 
      greenVal = 0;
    }
  }

  if (widget == blueButton) 
  {
    blueOn = !blueOn;
    if (blueOn == true) 
    { 
      blueVal = 255;
    }
    if (blueOn == false) 
    { 
      blueVal = 0;
    }
  }

  // Set screen background color based on which buttons have been pressed.
  background(redVal, greenVal, blueVal);
}

