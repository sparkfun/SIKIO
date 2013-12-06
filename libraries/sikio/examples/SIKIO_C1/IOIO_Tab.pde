/* 
   SparkFun SIKIO - Circuit 1
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

// Declare the IO pins we will use as outputs for the RGB LED.
DigitalOutput redLed, greenLed, blueLed;

// Here are variables to store the pins on the IOIO board we want to use.
int redPin = 3; // Pin 3 of the IOIO is the output to the red leg of the RGB LED.
int greenPin = 2;
int bluePin = 1;

void ioioSetup(IOIO ioio) throws ConnectionLostException 
{
  // Ready each pin for use as an output.
  redLed = ioio.openDigitalOutput(redPin);
  greenLed = ioio.openDigitalOutput(greenPin);
  blueLed = ioio.openDigitalOutput(bluePin);
}

void ioioLoop(IOIO ioio) throws ConnectionLostException 
{
  try 
  {
    // Turn each LED on or off based on their status variables.
    redLed.write(redOn);
    greenLed.write(greenOn);
    blueLed.write(blueOn);
    // Don't call this loop again for 100 milliseconds
    Thread.sleep(100);
  }
  catch (InterruptedException e) 
  {
  }
}
