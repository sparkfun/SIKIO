/* 
  SparkFun SIKIO - Circuit 6
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
*/

  AnalogInput photo; // Our photocell is an AnalogInput
  int photoPin = 39; // The pin for our potentiometer
  float photoVal; // Input analog values ranging from 0 to 1

void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // Ready analog input pin to read photocell
  photo = ioio.openAnalogInput(photoPin);
}

void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  try
  {
    // Read the photocell each 100 ms
    photoVal = photo.read();
    Thread.sleep(100);
  }
  catch (InterruptedException e) 
  {
  }
}
