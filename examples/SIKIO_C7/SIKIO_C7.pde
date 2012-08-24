/* SIKIO Circuit 7
 * Push button or apwidgets button saves picture from camera, sends it to twitter via twitpic
 * Pushbutton on Pin 4
 * by Ben Leduc-Mills
 *
 * From http://blog.blprnt.com/blog/blprnt/updated-quick-tutorial-processing-twitter
 * We need FOUR things to authenticate our sketch: A consumer key & secret, and an access token & secret. You can get all 4 of these things from the twitter developer page.
 
 *  1. Visit https://dev.twitter.com/ and login with your twitter username and password
 *  2. Click on the ‘Create an app’ button at the bottom right
 *  3. Fill out the form that follows – you can use temporary values (like “My awesome test application”) for the first three fields.
 *  4. Once you’ve agreed to the developer terms, you’ll arrive at a page which shows the first two of the four things that we need: 
 *      the Consumer key and the Consumer secret. Copy and paste these somewhere so you have them ready to access.
 *  5. To get the next two values that we need, click on the button that says ‘Recreate my access token’. Copy and paste those two values (Access token and Access token secret) so that we have all four in the same place.
 *
 *  6. To get the last one, from TwitPic, go to dev.twitpic.com, click on 'register', and fill out the form to get your API Key.  Save this with the rest of your special stuff.
 
 Consumer key  5c7u1e829C2d2cIiFaLiHQ
 Consumer secret  vbU7tgfZStiANl3JmkUsPLopa4RnCKR7ey9FlMZVVE
 Access token  64042332-o43rVU2ONKxaCECUR0RpNkgkRYWD73hOww3vbFGE
 Access token secret  3Xeg3NBt7XwirfKd09DJZeezqhrTlT3X6r4MpQukcU
 Twitpic API key 18478f54c9f0fa09d16b9d7dea1e7389
 
 Download twitter4j-android-2.2.6 from http://twitter4j.org/en/index.html#introduction
 Import twitter4j-core.jar & twitter4j-media-support-android.jar (you can drag them straight onto your sketch)
 Make sure your twitter app has read and write permissions.
 Make sure your android sketch has Camera,Internet, and Write External Storage permsissions, and that your phone has a wifi connection.
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

//Android libraries to make the camera and saving files work
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

//our twitter object
Twitter twitter;

//make a widget container and 1 button
APWidgetContainer widgetContainer; 
APButton tweet;

// Setup camera globals:
CameraSurfaceView gCamSurfView;
// This is the physical image drawn on the screen representing the camera:
PImage gBuffer;
Camera cam;

//we need two configuration builders, one for twitter and one for twitpic
ConfigurationBuilder cb = new ConfigurationBuilder();
ConfigurationBuilder cb2 = new ConfigurationBuilder();
String CONS_KEY = "5c7u1e829C2d2cIiFaLiHQ";
String CONS_SECRET = "vbU7tgfZStiANl3JmkUsPLopa4RnCKR7ey9FlMZVVE";
String ACCESS_TOKEN = "64042332-o43rVU2ONKxaCECUR0RpNkgkRYWD73hOww3vbFGE";
String ACCESS_SECRET = "3Xeg3NBt7XwirfKd09DJZeezqhrTlT3X6r4MpQukcU";
String TWITPIC_KEY = "18478f54c9f0fa09d16b9d7dea1e7389";
ImageUpload upload;

//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

void setup() {

  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();

  //Set the size of the stage, and the background to black.
  size(550, 550);
  background(0);
  smooth();

  //create new container for widgets
  widgetContainer = new APWidgetContainer(this); 

  //create new button from x- and y-pos. and label. size determined by text content
  tweet = new APButton(10, 10, "Tweet"); 

  //place buttons in container
  widgetContainer.addWidget(tweet);

  //do our authentications
  cb.setOAuthConsumerKey(CONS_KEY);
  cb.setOAuthConsumerSecret(CONS_SECRET);
  cb.setOAuthAccessToken(ACCESS_TOKEN);
  cb.setOAuthAccessTokenSecret(ACCESS_SECRET);
  cb.setMediaProviderAPIKey(TWITPIC_KEY);

  //build our twitter auth
  twitter = new TwitterFactory(cb.build()).getInstance();

  //do it again for twitpic
  cb2.setOAuthConsumerKey(CONS_KEY);
  cb2.setOAuthConsumerSecret(CONS_SECRET);
  cb2.setOAuthAccessToken(ACCESS_TOKEN);
  cb2.setOAuthAccessTokenSecret(ACCESS_SECRET);
  cb2.setMediaProviderAPIKey(TWITPIC_KEY);

  //build it for twitpic
  upload = new ImageUploadFactory(cb2.build()).getInstance(MediaProvider.TWITPIC); //Use ImageUploadFactory
}


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
  try {
    uploadPic(photo);
  } 
  catch (TwitterException te) {
  }
}

//takes local image file on our device and uploads it to TwitPic, then calls our update status funtion which takes the pic and posts it to twitter
public void uploadPic(File file) throws TwitterException {
  String url = null;
  if (file != null) {
    url = upload.upload(file);
    updateStatus(url);
  }
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
    try {
      uploadPic(photo);
    } 
    catch (TwitterException te) {
    }
  }
}


//take the url of the twitpic image we just uploaded and puts it into a new twitter status update
public void updateStatus(String url) {

  try {
    Status status = twitter.updateStatus("new pic " + url);
  } 
  catch (TwitterException te) {
  }
}

