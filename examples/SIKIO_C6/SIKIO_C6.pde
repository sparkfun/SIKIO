/* 
   SparkFun SIKIO - Circuit 6
   Hardware Concept: Analog In
   Android Concept: Datalogging and Graphing
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This example shows how the main Processing file (in this case, SIKIO_C0_quickstart.pde)
   and the IOIOThread.pde file interact through the use of a global variable. The main .pde 
   file controls the user interface and the IOIOThread.pde controls the IOIO board. 
   
   HARDWARE:
   -photocell
   -10k
   
   OPERATION:
   The sketch opens and reads an analog value off of the photocell. A line is printed, where the 
   height of the line depends on how much light is hitting the photocell. There is also a button
   that can be hit to log the analog data to a txt file onto your Android's removable storage.
   To access the data you logged, plug your Android back into the computer, turn on USB Storage, 
   and you should see a text file called 'sensorValues.txt' in your main directory. The line grows
   taller the darker it is. 
   
   Make sure you check the WRITE_EXTERNAL_STORAGE permission in addition to the normal 
   INTERNET permssion under 'sketch permissions'. 
*/

// Import APWidgets library - download from: http://code.google.com/p/apwidgets/downloads/list
import apwidgets.*;

//Import IOIO library - this is from the link in the install section of your SIKIO guide.
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

//We need the android.os library to check if our external media is available and writable
import android.os.*;

//Create a IOIO instance.
IOIO ioio = IOIOFactory.create();

//Create a thread for our IOIO code.
IOIOThread thread1; 

//We're going to use text in this example, so we need a font.
PFont font;

//We need to keep track of the button value and be able to print the value, so we use string.
String s;

//These two variables hold the state of storage device's availability. 
boolean mExternalStorageAvailable = false;
boolean mExternalStorageWriteable = false;

//These will hold some feedback statements. 
String s1, s2, s3;

//Make a widget container and 1 button
APWidgetContainer widgetContainer;
APButton start;

void setup() {

  //Pick a font - PFont.list()[0] is good, because it will list the available fonts on our system as an array 
  //and just pick the first one.
  font = createFont(PFont.list()[0], 32);
  textFont(font);

  //Instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds.
  //The wait time is the time in between interations of the thread.  
  thread1 = new IOIOThread("thread1", 100);
  //Start our thread.
  thread1.start();
  
  //Here are your drawing options.
  noStroke(); //disables the outline
  rectMode(CENTER); //place rectangles by their center coordinates, (the default is the TL corner)
  
  //This is a method that checks whether local storage is accessible and writable.
  checkStorage();

  //Create a new container for widgets.
  widgetContainer = new APWidgetContainer(this);
  start = new APButton(10, 150, "start");
  widgetContainer.addWidget(start);
}

void draw() {

  background(0);
  
  //Draw a verticle bar graph.
  stroke(255, 0, 0); //red
  strokeWeight(30); //width of line in pixels
  //Now draw a line that corresponds to our current sensor reading.
  line(width/2, height, width/2, height - (thread1.photoVal * 1000));

  //We can print the analog value, log status, and whether or not the SD
  //card is available.
  text("Analog Value: " + thread1.photoVal, 10, 50);
  text("Log Status: " + s3, 10, 100);
  //text("Accessible: " + s1, 10, 150);
  //text("Writable: " + s2, 10, 200);
}

//This function handles the button action. 
void onClickWidget(APWidget widget) {
  
  if (widget == start) {
    s3 = "got button press";

    try {
      //update status
      s3 = "recording";
       
      //Get the external storage directory. 
      File root = Environment.getExternalStorageDirectory();
      
      //if we can write to our storage, create a text file, and fire up a BufferedWriter to write to it
      if (root.canWrite()) {
        File sensorValues = new File(root, "sensorValues.txt");
        FileWriter writer = new FileWriter(sensorValues);
        BufferedWriter out = new BufferedWriter(writer);
        
       //We just want to take a few seconds worth of data when we hit the button. 
       for (int i = 0; i < 700000; i++) {
         //take 1 of every 100, don't need too many values too quickly
         if (i%100 == 0) {
           //write to our text file
           out.write(i + thread1.photoVal + "/r");
         }
       }
        
       //Close our BufferedWriter.
       out.close();

       //We're done!
       s3 = "done";
      }
    } 
    catch (IOException e) {
      //Let us know if we couldn't log for some reason.
      s3 = "execption";
    }
  }
}

//This function checks the removable storage device to see if it is ready.
//There are some global variables s1 and s2 that can print debug information.
public void checkStorage() {

  //Get the readable/writable state of our media storage
  String state = Environment.getExternalStorageState();

  if (Environment.MEDIA_MOUNTED.equals(state)) {
    // We can read and write the media
    mExternalStorageAvailable = mExternalStorageWriteable = true;
    s1 = s2 = "true";
  } 
  else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
    // We can only read the media.
    mExternalStorageAvailable = true;
    s1 = "true";
    mExternalStorageWriteable = false;
    s2 = "false";
  } 
  else {
    //Something else is wrong. It may be one of many other states, but all we need
    //to know is we can neither read nor write.
    mExternalStorageAvailable = mExternalStorageWriteable = false;
    s1 = s2 = "false";
  }
}

