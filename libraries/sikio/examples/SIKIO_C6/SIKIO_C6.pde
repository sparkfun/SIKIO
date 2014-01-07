/* 
   SparkFun SIKIO - Circuit 6
   Hardware Concept: Analog In
   Android Concept: Datalogging and Graphing
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This example shows how to make a simple circuit with a photocell to collect light intensity 
   data and display this information on screen. You also how to use a button log this data 
   to a text file on your Android's removable storage. 
   
   HARDWARE:
   -photocell
   -10k
   
   OPERATION:
   The sketch opens and reads an analog value off of the photocell. A line is printed, where the 
   height of the line depends on how much light is hitting the photocell. There is also a on-screen
   button that can be hit to log the analog data to a txt file onto your Android's removable storage.
   To access the data you logged, plug your Android back into the computer, turn on USB Storage, 
   and you should see a text file called 'sensorValues.txt' in the Sikio folder of your main directory.
   
   Make sure you check the WRITE_EXTERNAL_STORAGE permission in addition to the normal 
   INTERNET permssion under 'sketch permissions'. It should be checked by default.
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

import apwidgets.*; // For creating a button
import android.os.*; // For checking if our external media is available and writable
import java.io.*; // For file IO, reading and writing to external media

// For updating media scanner to let computer's file manager be aware of new file
import android.content.Intent;
import android.net.Uri;

PFont font; // Declaring font for using text on screen

// These variables hold the state of storage device's availability, write access, and logging status. 
String storageAvailable, storageWritable, logStatus;

// Create a widget container and the log button
APWidgetContainer widgetContainer;
APButton logButton;

void setup() 
{
  new SikioManager(this).start();
  
  // Use default font, size 32
  font = createFont(PFont.list()[0], 32);
  textFont(font);

  // This is a method that checks whether local storage is accessible and writable, for debugging.
  checkStorage();

  // Create a our widget container and place our log button.
  widgetContainer = new APWidgetContainer(this);
  logButton = new APButton(10, 150, "Log Data");
  widgetContainer.addWidget(logButton);
  
  logStatus = "ready"; // Log status is in ready state until button is pressed, purely for display.
}

void draw() 
{
  background(0); // Clear background.
  
  // Draw a verticle bar graph to show sensor reading.
  stroke(255, 0, 0); // Set line color to red.
  strokeWeight(30); // Set width of line in pixels.
  // Now draw a line that corresponds to our current sensor reading.
  line(width/2, height, width/2, height - (photoVal * 1000));

  // Print the photocell sensor input as well as SD card logging status.
  text("Analog Value: " + photoVal, 10, 50);
  text("Log Status: " + logStatus, 10, 100);
  
  // Show if media storage is available and writable, for debugging.
  //text("Available: " + storageAvailable, 10, 150);
  //text("Writable: " + storageWritable, 10, 200);
}

// This function is called when the log button is pressed. 
void onClickWidget(APWidget widget) 
{
  // Checks if logButton was pressed
  if (widget == logButton) 
  {
    logStatus = "got button press"; // logStatus reflects that button was pressed

    try 
    {
      // Update status to indicate we are recording sensor values to a file
      logStatus = "recording";
      
      // Create a Sikio folder if it's not present
      File folder = new File("/sdcard/Sikio/");
      folder.mkdirs();
       
      // Get the external storage directory. 
      File root = Environment.getExternalStorageDirectory();
      
      // If we can write to our storage, create a text file, and fire up a BufferedWriter to write to it
      if (root.canWrite()) 
      {
        File sensorValues = new File(root, "/Sikio/sensorValues.txt");
        FileWriter writer = new FileWriter(sensorValues);
        BufferedWriter out = new BufferedWriter(writer);
        
       // We just want to take a few seconds worth of data when we hit the button. 
       for (int i = 0; i < 1000000; i++) 
       {
         // Take 1 of every 1000, don't need too many values too quickly
         if (i % 1000 == 0) 
         {
           // Write values to our text file
           out.write((i / 1000) + "\t" + photoVal + "\r\n");
         }
       }
        
       // Close our BufferedWriter.
       out.close();
       
       // Update the Android's file system so that the file will be shown 
       // when the Android is plugged back into the computer (without restarting the device)
       sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED, Uri.parse("file://" + root + "/Sikio/")));

       // We're done! Update status so user is aware that the file logging has finished.
       logStatus = "done";
      }
    } 
    catch (IOException e) 
    {
      // Let us know if we couldn't log for some reason.
      logStatus = "exception";
    }
  }
}

// This function checks the removable storage device to see if it is ready.
// The global variables storageAvailable and storageWritable can be used to print debug information.
public void checkStorage() {

  // Get the readable/writable state of our media storage
  String state = Environment.getExternalStorageState();

  if (Environment.MEDIA_MOUNTED.equals(state)) 
  {
    // We can read and write to files.
    storageAvailable = storageWritable = "true";
  } 
  else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) 
  {
    // We can only read files.
    storageAvailable = "true";
    storageWritable = "false";
  } 
  else 
  {
    // Something else is wrong. We can neither read nor write to a file.
    storageAvailable = storageWritable = "false";
  }
}

