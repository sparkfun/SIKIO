/* 
  SparkFun SIKIO - Circuit 7
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

DigitalInput button; // Declare button as DigitalInput
int buttonPin = 8; // Use pin 8 for our button
boolean buttonVal; // Button value is digital, either 0 OR 1 (true or false)

void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // Ready pin as digital input for button
  button = ioio.openDigitalInput(buttonPin);
} 

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  try
  {
    // Read external button every 100 ms
    buttonVal = button.read();
    Thread.sleep(100);
  }
  catch (InterruptedException e) 
  {
  }
}
