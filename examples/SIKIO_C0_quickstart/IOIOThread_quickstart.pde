/* 
  SparkFun SIKIO - Quickstart
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
  PURPOSE:
  This is our thread class, it's a subclass of the standard thread class that comes with Processing.
  We're not really doing anything dramatic, just using a thread (i.e. a separate process than the main .pde file)
  to control the IOIO board. You can define global variables in the main sketch and use them here.
  
  More info on how the Processing Thread class works, see here:
  http://wiki.processing.org/w/Threading
  
 */

//This is a class for the IOIO thread. It is similar to the MainActivity class in Android programming, except 
//our "MainActivity" extends to a thread that runs separate than the main .pde file. In other words, the IOIOThread 
//class inherits all of the attributes of the Java thread class. All this is doing is allowing us to use the 
//'thread' class without having to write too much extra configuration code for the thread. 
class IOIOThread extends Thread {

  //Variables for our Thread constuctor. These define the threads properties 
  boolean running;  //is our thread running?
  String id; //in case we want to name our thread
  int wait; //how often our thread should run
  int count; //if we wanted our thread to timeout, we could put a counter on it, we don't use it here
  
  /*
      Your global variables or declarations for the IOIO go here. For examples on how to use the IOIO 
      libaries, see the IOIO wiki: https://github.com/ytai/ioio/wiki
  */
  
  DigitalOutput led;  //DigitalOutput type for the onboard led

  //Our Thread constructor, here we configure the thread.
  IOIOThread(String s, int w) {
    id = s; //not using this
    wait = w; //not using this
    running = false; //not running yet
    count = 0; //not using this
  }

  //start() is a method of the Java thread class, we will override this method and use it as a setup funcion
  //where we can define variables. The thread starts when you call thread1.start() in the main .pde file.
  void start() {
    
    running = true; //we are now running the thread
    //try connecting to the IOIO board, handle the case where we cannot or the connection is lost
    try {
      //ioio.waitForConnect();
      IOIOConnect();  //this function is down below and not part of the IOIO library
    } 
    catch (ConnectionLostException e) {
    }
    
    /*
      Your setup code that controls the IOIO goes here. For examples on how to use the IOIO libaries, see the
      IOIO wiki: https://github.com/ytai/ioio/wiki
    */
    
    //Try setting our led pin to the onboard led, which has a constant 'LED_PIN' associated with it
    try {
      led = ioio.openDigitalOutput(IOIO.LED_PIN);
    } 
    catch (ConnectionLostException e) {
    }

    //Now we can envoke our start method. Leave this here. 
    super.start();
  }

  //Another method from the Java thread class. We can put a while(1) loop in here so that we can have the thread
  //run unti the program is closed. 
  void run() {
    
    //While our sketch is running, turn on or off the led accordingly and keep track of the lightOn boolean.
    while (running) { 
      
      /*
        Your main loop code that controls the IOIO goes here. For examples on how to use the IOIO libaries, see the
        IOIO wiki: https://github.com/ytai/ioio/wiki
      */
       
      try {
        //LED ON
        led.write(false);
        lightOn = true;
        //Delay
        try {
          sleep(500);
        } 
        catch (Exception e) {
        }
        
        //LED OFF
        led.write(true);
        lightOn = false;
        //Delay
        try {
          sleep(500);
        } 
        catch (Exception e) {
        }
      } 
      catch (ConnectionLostException e) {
      }
    }
  }

  //Often we may want to quit or stop or thread, but we are not using it here.
  void quit() {
    
    running = false;
    ioio.disconnect();
    interrupt();
  }
  
   //A simple little method to try connecting to the IOIO board
  void IOIOConnect() throws ConnectionLostException {

    try {
      ioio.waitForConnect(); //from the IOIO library
    }
    catch (IncompatibilityException e) {
    }
  }
}

