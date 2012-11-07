/* 
  SparkFun SIKIO - Circuit 3
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
  int count;
  
  //Define your variables here.
  PwmOutput piezo; //Piezo buzzers are pulse-modulated output
  int piezoPin = 11; // pin for our potentiometer
  int freq = 523; //our beginning frequency

  IOIOThread(String s, int w) {
    id = s;
    wait = w;
    running = false;
    count = 0;
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

      //Open and close the piezo pin just to give us a connection and set the duty cycle
      piezo = ioio.openPwmOutput(piezoPin, freq); 
      piezo.setDutyCycle(.5);
    } 
    catch (ConnectionLostException e) {
    }
    
    //Olose it so we don't get a tone when opening the app.
    piezo.close();

    //don't forget this!
    super.start();
  }

  void run() {

    while (running) {
    
      //All of our actions happen off the button presses in the Processing code, so there
      //isn't anything in our run method.
      try {
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }
  }

  void quit() {
    running = false;
    piezo.close();
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

