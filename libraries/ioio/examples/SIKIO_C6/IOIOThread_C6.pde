/* 
  SparkFun SIKIO - Circuit 6
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
  PURPOSE:
  This is our thread class, it's a subclass of the standard thread class that comes with Processing.
  We're not really doing anything dramatic, just using a thread (i.e. a separate process than the main .pde file)
  to control the IOIO board. You can define global variables in the main sketch and use them here.
  
  More info on how the Processing Thread class works, see here:
  http://wiki.processing.org/w/Threading
  
*/

class IOIOThread extends Thread {
  
  //Variables for our Thread constuctor. These define the threads properties. 
  boolean running; //is our thread running?
  String id; 
  int wait;  //how often we want our thread to run
  
  //Variables used in this sketch.
  //DigitalInput button; //our button is a DigitalInput
  AnalogInput photo; //our photocell is an AnalogInput
  //int buttonPin = 4; //pin for our led
  int photoPin = 39; // pin for our potentiometer
  float photoVal; //our analog values range from 0 to 1
  //boolean buttonVal; //digital in is either 0 OR 1 (true or false)


  IOIOThread(String s, int w) {
    id = s;
    wait = w;
    running = false;
  }


  void start() {
    running = true;

    try {
      //connect to the IOIO
      IOIOConnect();
    } 
    catch (ConnectionLostException e) {
    }

    try {

      //try opening our input pins
      //button = ioio.openDigitalInput(buttonPin);
      photo = ioio.openAnalogInput(photoPin);
    } 
    catch (ConnectionLostException e) {
    }

    //don't forget this!
    super.start();
  }

  void run() {

    while (running) {

      try {
        //while we're running, read our potentiometer and button values
        photoVal = photo.read();
      } 
      catch (ConnectionLostException e) {
      }
      catch (InterruptedException e) {
      }

      try {
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }
  }

  void quit() {
    running = false;
    ioio.disconnect();
    interrupt();
  }

  void IOIOConnect() throws ConnectionLostException {

    try {
      ioio.waitForConnect();
    }
    catch (IncompatibilityException e) {
    }
  }
}

