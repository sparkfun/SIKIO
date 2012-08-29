// SparkFun IOIO Kit, Example 4 - Servo Control (continued)

// Thread that contains IOIO commands
class myIOIOThread extends Thread {

  boolean running;  // Is the thread running, true or false?
  String id; // Thread ID
  int wait; // Thread sleep time in milliseconds
  PwmOutput servo;  // Declaring Servo PWM output on the IOIO

  // Initialize Thread variables
  myIOIOThread(String s, int w) {
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

    // Initialize PWM pin for Servo and set initial duty cycle
    try {
      servo = ioio.openPwmOutput(5, 50); // Pin 5, 50Hz (period = 20ms)
      servo.setDutyCycle(servo_duty);
    } 
    catch (ConnectionLostException e) {
    }

    super.start();
  }
  
  // Set Servo Dutycycle every time thread is run
  void run() {
    while (running) {
      try {
        servo.setDutyCycle(servo_duty);
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

