/* 
  SparkFun SIKIO - Circuit 4
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

PwmOutput servo;  // Declaring Servo PWM output on the IOIO
int servoPin = 5; // Pin for the Servo PWM signal

void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // Initialize PWM pin for Servo and set initial duty cycle
  servo = ioio.openPwmOutput(servoPin, 50); // Pin 5, 50Hz (period = 20ms)
  servo.setDutyCycle(servo_duty); // Sets angle of Servo
}

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  try 
  {
    // Set new Servo angle based on duty cycle set by cursor position
    servo.setDutyCycle(servo_duty);
    // Don't call this loop again for 100 milliseconds
    Thread.sleep(100);
  }
  catch (InterruptedException e) 
  {
  }
}
