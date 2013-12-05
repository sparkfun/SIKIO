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
   This example requires a motor, a NPN transistor, and a 10k resistor.
   
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

import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.text.format.Time;

// Grab IOIO libraries
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

APWidgetContainer widgetContainer; 
APEditText textField;

// Create IOIO object and declare thread
IOIO ioio = IOIOFactory.create();
IOIOThread thread1; 

long endTimeMillis=0;
long inputTime=0;
int motorOn=0;
long countdown=0;
Time hitStart = new Time();
Time now = new Time();

void setup() {
  // Create and start IOIO thread
  thread1 = new IOIOThread("thread1", 100);
  thread1.start();
  
  widgetContainer = new APWidgetContainer(this); //create new container for widgets
  textField = new APEditText(20, 75, displayWidth/3, 100); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(textField); //place textField in container
  textField.setInputType(InputType.TYPE_CLASS_NUMBER);
  textField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  textField.setCloseImeOnDone(true);
  textSize(30);
}

void draw() {
  background(0);
  
  now.setToNow();
  
  if(motorOn==1)
  {
    countdown = (endTimeMillis - now.toMillis(false))/1000;
    if (countdown <=0)
    {
      motorOn=0;
      countdown=0;
    }
    
  }



  //text(textField.getText(), 10, 10); //display the text in the text field
  text("Enter Seconds to Turn on Motor:",20,50);
  text("Countdown:",20,230);
  text(int(countdown), 20, 270);
  //text(hit.toMillis(false), 10, 50);
  //text(now.format("%H%M%S"), 10, 50);
}

void onClickWidget(APWidget widget) {
  if (widget == textField) {
    inputTime = int(textField.getText());
    inputTime = inputTime * 1000; //convert sec to ms
    hitStart.setToNow();
    motorOn=1;
    endTimeMillis = hitStart.toMillis(false) + inputTime;
  }
}

