/* 
  SparkFun SIKIO - Circuit 2
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

// Declare the IO pins for the button and potentiometer.
DigitalInput button; // Our button is a DigitalInput
AnalogInput pot; // Our potentiometer is an AnalogInput

// Variables to store pin numbers
int buttonPin = 7;
int potPin = 40;

// Variables to store analog and digital values
float potVal; // Our analog values range between 0 and 1
boolean buttonVal; // Digital is either 0 OR 1 (true or false)

void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // Opening the input pins.
  button = ioio.openDigitalInput(buttonPin);
  pot = ioio.openAnalogInput(potPin);
} 

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  try
  {
    // While we're running, read our potentiometer and button values. The pot value is a
    // number between 0 and 1. Button value is either a 0 or 1.
    potVal = pot.read();
    buttonVal = button.read();
    // Don't call this loop again for 100 milliseconds
    Thread.sleep(100);
  } 
  catch (InterruptedException e) 
  {
  }
}
