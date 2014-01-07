/*
   SparkFun SIKIO - Circuit 7
   Hardware Concept: Digital Input
   Android Concept: Camera, file saving
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   Takes a picture when an external button is hit. A Sikio folder is created in the root directory
   of the SD card and the image is saved to a file called image.jpg in that folder.
   
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
import android.content.Intent;
import android.net.Uri;

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
  
  // Create new container for the button
  widgetContainer = new APWidgetContainer(this); 

  // Create new button at x and y pos with label. Size determined by text content
  photoButton = new APButton(10, 10, "Take Pic"); 

  // Place buttons in container
  widgetContainer.addWidget(photoButton);
}

// This overrides our Activity and forces the onResume state. You must do this when
// using much of the internal hardware on your Android. 
void onResume() 
{
  super.onResume();
  
  // Create our 'CameraSurfaceView' object that works the magic:
  gCamSurfView = new CameraSurfaceView(this.getApplicationContext());
}


void draw() 
{
  // If our physical button gets pressed, save the image
  if (buttonVal == false) 
  {
    savePic();
  }
}

// Save image function - saves the current gBuffer to our local storage
public void savePic() 
{
  // Create a Sikio folder if it's not present
  File folder = new File("/sdcard/Sikio/");
  folder.mkdirs();
  
  // Delete old image if present
  File photo = new File("/sdcard/Sikio/image.jpg");
  photo.delete();

  // Get the SD card's root directory
  String root = Environment.getExternalStorageDirectory().getPath();

  // Save the image to the Sikio folder
  gBuffer.save(root + "/Sikio/image.jpg");
  
  // Update the Android's file system so that the file will be shown 
  // when the Android is plugged back into the computer (without restarting the device)
  sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED, Uri.parse("file://" + root + "/Sikio/")));
}

// onClickWidget is called when a widget is clicked/touched
void onClickWidget(APWidget widget) {

  // Checks to see if our 'take picture' button was pressed
  if (widget == photoButton) 
  { 
    savePic(); // Save the image
  }
}

