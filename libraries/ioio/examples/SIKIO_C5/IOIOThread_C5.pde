// SparkFun IOIO Kit, Example 5
// Thread that contains IOIO commands
class IOIOThread extends Thread {

  boolean running;  // Is the thread running, true or false?
  String id; // Thread ID
  int wait; // Thread sleep time in milliseconds
  
  DigitalOutput motor;
  int motorPin = 18;

  // Initialize Thread variables
  IOIOThread(String s, int w) {
    id = s;
    wait = w;
    running = false;
  }

  // Start thread and attempt connection to the IOIO
  void start() {
    running = true;
    try {
      IOIOConnect();
    } 
    catch (ConnectionLostException e) {
    }

    try {
      // Turn motor off here
      motor = ioio.openDigitalOutput(motorPin); //use pin 18
      motor.write(false);
    } 
    catch (ConnectionLostException e) {
    }

    super.start();
  }
  
  void run() {
    while (running) {

      try {
        // check timing variable status
        // if timer's still going, keep motor on, otherwise
        // turn the pin off
        if (motorOn ==1)
        {
          motor.write(true);
        }
        else
        {
          motor.write(false);
        }
      } 
      catch (ConnectionLostException e) {
      }
      
      // Put thread back to sleep after running
      try {
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }
  }

  // Kill thread and disconnect from the IOIO
  void quit() {
    running = false;
    ioio.disconnect();
    interrupt();
  }


  // Function that connects Android to the IOIO
  void IOIOConnect() throws ConnectionLostException {
    try {
      ioio.waitForConnect();
    }
    catch (IncompatibilityException e) {
    }
  }
}

