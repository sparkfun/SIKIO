/* 
   SparkFun SIKIO - C5 - Motor Control
   Hardware Concept: Transistor, Motor
   Android Concept: Inserting Text
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This application is intended to teach both how to input data into your android as well as
   use that data to control a motor.  Give the application an integer and hit enter, the
   application will then turn on the motor for that many seconds as well as display a countdown
   timer on your phone for visual feedback. The motor is turned on using a transistor because
   a digital pin of the microcontroller can't supply enough current to drive the motor. 
   
   HARDWARE:
   -DC motor
   -NPN transistor
   -330 Ohm resistor
   -Diode
   
   OPERATION:
   Upload the application to your Android. Connect the 10k resistor (or resistor + wire) to
   to the base of the transistor (middle pin) in your breadboard.  Connect the emitter of the
   transistor to ground.  Connect the collector of the transistor to one pin of the motor. 
   Connect the other pin of the motor to the 5V rail. Load up the application and make sure
   your Android is connected to a powered IOIO with a USB cable. Input a number into the
   text box.  This is the number of seconds the motor will turn on for. Once you hit enter,
   the motor will turn on for the prescibed amount of seconds and a countdown timer will
   display on your android device. The motor is on whenever the 'motorOn' variable is equal 
   to one. An android time widget is used to keep track of the seconds and update the
   'motorOn' variable.
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

// Libraries for text input
import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.text.format.Time;

// Needed for text field
APWidgetContainer widgetContainer; 
APEditText textField;

int motorOn = 0; // Keeps track of whether motor should be turned on, 1 if so

// Variables to help keep track timer
long endTimeMillis = 0; // When the timer should end
long inputTime = 0; // When the timer was started
long countdown = 0; // How long timer has left before stopping
Time hitStart = new Time(); // Used to get time at button press
Time now = new Time(); // Used to get current time and figure out how much time remains

void setup() 
{
  new SikioManager(this).start();
  
  // Set up text field to allow user to input numbers and press done  
  widgetContainer = new APWidgetContainer(this); // Create new container for widgets
  textField = new APEditText(20, 75, displayWidth/3, 100); // Create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(textField); // Place textField in container
  textField.setInputType(InputType.TYPE_CLASS_NUMBER); // Use numeric inputs
  textField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  textField.setCloseImeOnDone(true);
  textSize(30);
}

void draw() 
{
  // Clear screen and set background to black
  background(0);
  
  now.setToNow(); // Get current time
  
  // If the motor is running, calculate time left on timer, if none is left, set motorOn variable to 0 so motor will turn off
  if(motorOn==1)
  {
    countdown = (endTimeMillis - now.toMillis(false))/1000;
    if (countdown <=0)
    {
      motorOn=0;
      countdown=0;
    }
  }

  // Display Countdown and associated text on screen
  text("Enter Seconds to Turn on Motor:",20,50);
  text("Countdown:",20,230);
  text(int(countdown), 20, 270);
  
  // Extra data that could be of interest to display
  //text(textField.getText(), 10, 10); // Display the text in the text field
  //text(hit.toMillis(false), 10, 50);
  //text(now.format("%H%M%S"), 10, 50);
}

// When text field is entered and done is hit, find input time, and calculate the end time for the timer, turn motor variable on
void onClickWidget(APWidget widget) 
{
  if (widget == textField) 
  {
    inputTime = int(textField.getText());
    inputTime = inputTime * 1000; // Convert sec to ms
    hitStart.setToNow();
    motorOn = 1;
    endTimeMillis = hitStart.toMillis(false) + inputTime;
  }
}
