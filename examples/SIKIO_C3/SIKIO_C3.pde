/* SIKIO Circuit 3
 * by Ben Leduc-Mills
 * Pulse Width Modulation - PWM Output
 * Tone generation with a Piezo buzzer
 * Peizo Buzzer on IOIO pin 11
 * More on PWM Output with IOIO: https://github.com/ytai/ioio/wiki/PWM-Output
 * Extra to-do:  Make the black keys work too.
 */

// Import APWidgets library - download from: http://code.google.com/p/apwidgets/downloads/list
import apwidgets.*;

//Import IOIO library - this is from the link in the install section of your SIKIO guide
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;


//create a IOIO instance
IOIO ioio = IOIOFactory.create();

//create a thread for our IOIO code
IOIOThread thread1; 

//We're going to use text in this example, so we need a font
//PFont font;

//string to keep track of button value
//String s;

//make a widget container and 3 buttons, one for each color
APWidgetContainer widgetContainer; 
APButton c;
APButton d;
APButton e;
APButton f;
APButton g;
APButton a;
APButton b;
APButton c2;

//int pos;

void setup() {

  //pick a font - PFont.list()[0] is good because it will list the available fonts on our system as an array and just pick the first one
  //  font = createFont(PFont.list()[0], 32);
  //  textFont(font);

  //instantiate our thread, with a thread id of 'thread1' and a wait time of 100 milliseconds
  thread1 = new IOIOThread("thread1", 100);
  //start our thread
  thread1.start();

  size(480, 800); 
  smooth();
  noStroke();
  fill(255);

}

void draw() {

  //Set background to black
  background(#000000);

  //pos = mouseX;
  //draw white keys
  fill(255);
  stroke(155);
  rect(50, 10, 50, height); //c
  rect(100, 10, 50, height); //d
  rect(150, 10, 50, height); //e
  rect(200, 10, 50, height); //f
  rect(250, 10, 50, height); //g
  rect(300, 10, 50, height); //a
  rect(350, 10, 50, height); //b
  rect(400, 10, 50, height); //c

  //draw black keys
  fill(0);
  rect(75, 10, 50, 300); //c#
  rect(125, 10, 50, 300); //d#
  rect(225, 10, 50, 300); //f#
  rect(275, 10, 50, 300); //g#
  rect(325, 10, 50, 300); //Bb
}


//a little function to open the piezo pin at the correct frequency and play a tone, 
//the length of which is determined by the value we pass to the sleep() function

void playTone(int freq) {

  try {
    thread1.piezo = ioio.openPwmOutput(thread1.piezoPin, freq);
    thread1.piezo.setDutyCycle(.5);
  } 
  catch (ConnectionLostException e) {
  }
  try {
    thread1.sleep(100); 
  } 
  catch (InterruptedException e) {
  }
  thread1.piezo.close();
}


//this is how Android handles touch events

public boolean surfaceTouchEvent(MotionEvent event) {  

  //there was a touch event - what kind
  int action = event.getAction();
  
  //get the X position of where the touch was, so we know which note to play
  int pos = (int)event.getX();

  //the the action was a touch down on the screen, play a note based on the positon of the touch
  if (action == MotionEvent.ACTION_DOWN) {

    if (pos < 100) {
      playTone(523);
      
    }  

    if (pos >= 100 && pos < 150) {
      playTone(587);
     
    }

    if (pos >= 150 && pos < 200) {
      playTone(659);
      
    }

    if (pos >= 200 && pos < 250) {
      playTone(698);
      
    }

    if (pos >= 250 && pos < 300) {
      playTone(784);
      
    }

    if (pos >= 300 && pos < 350) {
      playTone(880);
      
    }

    if (pos >= 350 && pos < 400) {
      playTone(988);
      
    }
    if (pos > 400) {
      playTone(1047);
      
    }
  }

  // if you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(event);
}


