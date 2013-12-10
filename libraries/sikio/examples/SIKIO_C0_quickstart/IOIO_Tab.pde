/* 
  SparkFun SIKIO - Quickstart
  CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
  PURPOSE:
  This is where we place code that controls the IOIO board. Global variables 
  defined in the main sketch can be used here. In this example, we learn to use
  a Digital IO pin as an output to control the onboard LED.  
*/

// Your global variables or declarations for the IOIO go here. For examples on how to use the IOIO 
// libaries, see the IOIO wiki: https://github.com/ytai/ioio/wiki
DigitalOutput led;  //DigitalOutput type for the onboard led
  
// The initialization/setup code for the IOIO goes here.
void ioioSetup(IOIO ioio) throws ConnectionLostException
{
  // We select the pin we want to use for the LED and ready that pin for use.
  led = ioio.openDigitalOutput(IOIO.LED_PIN);
}

// The following loop function is called repeatedly while the application is still running
// on your Android device. This particular function toggles the LED and 'lightON' variable.
// It's imporant to add a sleep command so your Android device can devote its resources
// to other applications.
void ioioLoop(IOIO ioio) throws ConnectionLostException
{
  // Try/catch block necessary for using Thread.sleep function
  try 
  {
    led.write(lightOn); // Turn the LED on or off
    lightOn = !lightOn; // Change the lightOn from true to false or vice versa
    Thread.sleep(500); // Don't call this loop again for 500 milliseconds
  }
  // The catch block can be used to find out more information about an error
  // In this case it's unused but needs to be present since the sleep function can result in this type of error
  catch (InterruptedException e) 
  {
  }
}
