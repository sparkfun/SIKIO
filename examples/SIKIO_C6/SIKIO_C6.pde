/* SIKIO Circuit 6
 * by Ben Leduc-Mills
 * Analog In, Graphing, & Data Logging
 * Reading from a photocell
 * Potentiometer on Pin 40, Button on Pin 4
 * Make sure you check the WRITE_EXTERNAL_STORAGE permission in addition to the normal INTERNET permssion under 'sketch permissions'
 * To access the data you logged, plug your phone back into the computer, turn on USB Storage, and you should see a text file call 'sensorValues.txt' in your main directory
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

//we need the android.os library to check if our external media is available and writable
import android.os.*;




//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

//We're going to use text in this example, so we need a font
PFont font;

//string to keep track of button value
String s;

int xPos = 1;

boolean mExternalStorageAvailable = false;
boolean mExternalStorageWriteable = false;
String s1, s2, s3;

APWidgetContainer widgetContainer; 
APButton start;

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

  //Set background to black
  background(#000000);

  //set orientation
  orientation(PORTRAIT);
  
  //Method that checks whether local storage is accessible and writable
  checkStorage();

  //create new container for widgets
  widgetContainer = new APWidgetContainer(this);
  start = new APButton(10, 150, "start");
  widgetContainer.addWidget(start);
}

void draw() {

  background(#000000);

  stroke(255);
  //draw a line that corresponds to our current sensor reading
  line(xPos, height, xPos, height - (thread1.photoVal * 1000));

  //if the line goes off the screen, start over
  if (xPos >= width) {
    xPos = 0;
  }
  else {
    xPos++;
  }


  text("Accessible: " + s1, 10, 50);
  text("Writable: " + s2, 10, 100);
  text("Status: " + s3, 10, 150);
}


void onClickWidget(APWidget widget) {

  if (widget == start) {

    s3 = "got button press";

    try {
      
      //update status
      s3 = "recording";
       
      //get the external storage directory 
      File root = Environment.getExternalStorageDirectory();
      
      //if we can write to our storage, create a text file, and fire up a BufferedWriter to write to it
      if (root.canWrite()) {
        File sensorValues = new File(root, "sensorValues.txt");
        FileWriter writer = new FileWriter(sensorValues);
        BufferedWriter out = new BufferedWriter(writer);
        
        //just a few seconds worth
        for (int i = 0; i < 100000; i++) {

          //take 1 of every 100, don't need too many values too quickly
          if (i%100 == 0) {
            //write to our text file
            out.write(i + "   " + thread1.photoVal + "\n");
          }
        }
        
        //close our BufferedWriter
        out.close();

        //we're done!
        s3 = "done";
      }
    } 
    catch (IOException e) {
      //let us know if we couldn't log for some reason
      s3 = "execption";
    }
  }
}



public void checkStorage() {

  //get the readable/writable state of our media storage
  String state = Environment.getExternalStorageState();

  if (Environment.MEDIA_MOUNTED.equals(state)) {
    // We can read and write the media
    mExternalStorageAvailable = mExternalStorageWriteable = true;
    s1 = s2 = "true";
  } 
  else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
    // We can only read the media
    mExternalStorageAvailable = true;
    s1 = "true";
    mExternalStorageWriteable = false;
    s2 = "false";
  } 
  else {
    // Something else is wrong. It may be one of many other states, but all we need
    //  to know is we can neither read nor write
    mExternalStorageAvailable = mExternalStorageWriteable = false;
    s1 = s2 = "false";
  }
}

