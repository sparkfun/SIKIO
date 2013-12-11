/* 
 SparkFun SIKIO - Circuit 3
 CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
 */

PwmOutput piezo; // Piezo buzzers are pulse-modulated output
int piezoPin = 11; // Pin for our piezo speaker

void ioioSetup(IOIO ioio) throws ConnectionLostException 
{
  // Open and close the piezo pin just to give us a connection and set the duty cycle
  piezo = ioio.openPwmOutput(piezoPin, freq); 
  piezo.setDutyCycle(.5);
  piezo.close(); // To stop from the piezo from making sound on startup
}

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  // If a 'piano' key has been pressed, play that note for 100 ms
  if (playTone == true) 
  {
    try 
    {
      piezo = ioio.openPwmOutput(piezoPin, freq);
      piezo.setDutyCycle(.5);
      Thread.sleep(100);
    } 
    catch (InterruptedException e) 
    {
    }
    piezo.close(); // Turn off signal to piezo speaker
    playTone = false; // Set to false so note doesn't continuously play, and waits for another screen press
  }
}

