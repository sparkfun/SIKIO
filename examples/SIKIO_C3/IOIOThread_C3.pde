class IOIOThread extends Thread {

  boolean running; //is our thread running?
  String id; 
  int wait;  //how often we want our thread to run
  PwmOutput piezo; //Piezo buzzers are pulse-modulated output
  int count;
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

      //open and close the piezo pin just to give us a connection and set the duty cycle
      piezo = ioio.openPwmOutput(piezoPin, freq);
      piezo.setDutyCycle(.5);
    } 
    catch (ConnectionLostException e) {
    }
    
    //close it so we don't get a tone when opening the app
    piezo.close();

    //don't forget this!
    super.start();
  }

  void run() {

    while (running) {
    
      //all of our actions happen off the button presses in the Processing code

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
    //led.close();
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

