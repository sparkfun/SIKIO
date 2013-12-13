/* 
  SparkFun SIKIO - Circuit 5
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

DigitalOutput motor; // Declare motor as digital output
int motorPin = 18; // Use pin 18

void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // Ready pin and turn motor off here
  motor = ioio.openDigitalOutput(motorPin);
  motor.write(false);
}

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  try 
  {
    // motorOn will be equal to 1 if timer is still counting down, so keep motor running
    if (motorOn ==1)
    {
      motor.write(true);
    }
    else
    {
      motor.write(false);
    }
    // Don't call this loop again for 100 milliseconds
    Thread.sleep(100);
  } 
  catch (InterruptedException e) 
  {
  }
}

