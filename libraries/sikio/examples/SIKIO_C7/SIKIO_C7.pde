/*
   SparkFun SIKIO - Circuit 7
   Hardware Concept: Digital Input
   Android Concetp: Camera, file saving
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   Takes a picture when an external button is hit. The image is saved to the root directory
   of the SD card in a file called image.jpg.
   
   HARDWARE:
   -push button
   -1 10kOhm resistor
   
   OPERATION:
   In this example, you will connect a button to pin 8 of the IOIO. When the app opens, the 
   camera should be on. You can either hit the external push button or hit the on screen 
   button to take a picture.
 */

// Import APWidgets library - download from: http://code.google.com/p/apwidgets/downloads/list
import apwidgets.*;

//Import the IOIO libraries. If you want to interact with the IOIO board, you must 
//include all of these files. These come from the IOIO folder in your Processing ->
//libraries directory.
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

//Android libraries to make the camera and saving files work.
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.PreviewCallback;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.Surface;
import android.os.*;
import java.io.File;
import java.io.FileOutputStream;

//make a widget container and 1 button
APWidgetContainer widgetContainer; 
APButton tweet;

// Setup camera globals:
CameraSurfaceView gCamSurfView;
// This is the physical image drawn on the screen representing the camera:
PImage gBuffer;
Camera cam;

//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

void setup() {

  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();

  //Drawing options.
  //noStroke(); //disables the outline
  //rectMode(CENTER); //place rectangles by their center coordinates
  
  //background(0,0,0); //draw black background

  //create new container for widgets
  widgetContainer = new APWidgetContainer(this); 

  //create new button from x- and y-pos. and label. size determined by text content
  tweet = new APButton(10, 10, "Take Pic"); 

  //place buttons in container
  widgetContainer.addWidget(tweet);
}

//This overrides our Activity and forces the onResume state. You must do this when
//using much of the internal hardware on your Android. 
void onResume() {
  super.onResume();
  println("onResume()!");
  // Set orientation here, before Processing really starts, or it can get angry:
  orientation(LANDSCAPE);

  // Create our 'CameraSurfaceView' object that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}


void draw() {
  //if our physical button gets pressed, save the image
  if (thread1.buttonVal == false) {
    savePic();
  }
}

//save image function - saves the current gBuffer to our local storage and passes the filepath url to our upload function
public void savePic() {
  File root = Environment.getExternalStorageDirectory();
  File photo = new File(root, "image.jpg");
  //File photo = root + "/image.jpg";
  gBuffer.save(root+"/image.jpg"); 
  //close our BufferedWriter
  //out.close();
}

//onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {

  //same deal, but listens for our APWdiget button instead of the physical button
  if (widget == tweet) { 

    File root = Environment.getExternalStorageDirectory();
    File photo = new File(root, "image.jpg");
    //File photo = root + "/image.jpg";
    gBuffer.save(root+"/image.jpg"); 
    //close our BufferedWriter
    //out.close();
  }
}

