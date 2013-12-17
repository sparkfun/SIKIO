/*
   SparkFun SIKIO - Circuit 7
   Hardware Concept: Digital Input
   Android Concept: Camera, file saving
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
 
import ioio.lib.spi.*;
import ioio.lib.api.*;
import ioio.lib.util.*;
import ioio.lib.util.android.*;
import ioio.lib.android.bluetooth.*;
import ioio.lib.impl.*;
import sikio.*;
import ioio.lib.android.accessory.*;
import ioio.lib.api.exception.*;

import apwidgets.*; // For creating on screen button

// Android libraries for using the camera and saving files.
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

// Make a widget container and the 'take picture' button
APWidgetContainer widgetContainer; 
APButton photoButton;

// Camera globals:
CameraSurfaceView gCamSurfView;
PImage gBuffer; // Physical image drawn on screen representing the camera
Camera cam;

void setup() 
{
  new SikioManager(this).start();
  
  //create new container for widgets
  widgetContainer = new APWidgetContainer(this); 

  //create new button from x- and y-pos. and label. size determined by text content
  photoButton = new APButton(10, 10, "Take Pic"); 

  //place buttons in container
  widgetContainer.addWidget(photoButton);
}

//This overrides our Activity and forces the onResume state. You must do this when
//using much of the internal hardware on your Android. 
void onResume() 
{
  super.onResume();
  
  // Create our 'CameraSurfaceView' object that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}


void draw() 
{
  //if our physical button gets pressed, save the image
  if (buttonVal == false) 
  {
    savePic();
  }
}

//save image function - saves the current gBuffer to our local storage and passes the filepath url to our upload function
public void savePic() 
{
  File root = Environment.getExternalStorageDirectory();
  File photo = new File(root, "image.jpg");
  gBuffer.save(root+"/image.jpg"); 
}

//onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {

  //same deal, but listens for our APWdiget button instead of the physical button
  if (widget == photoButton) 
  { 
    savePic();
  }
}

