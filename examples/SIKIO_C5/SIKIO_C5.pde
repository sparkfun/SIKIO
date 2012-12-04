// SIKIO C5 - Controlling a Motor with Text Input

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

