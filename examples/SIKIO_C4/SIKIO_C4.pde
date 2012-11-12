/*
SparkFun IOIO Kit, Example 4 - Servo Control
Created 04/18/12 by Jordan McConnell at SparkFun Electronics

This is a simple Android app made with Processing
The purpose is to demonstrate basic servo motor control
 using one of the PWM pins on the IOIO board.

Instructions:
1. Load code into Processing 2.0a5
2. Connect your Android to the computer with a USB cable
3. Using Android mode, go to Sketch -> Run on Device (Ctrl+shift+r)
4. If that succeeded, connect a power source to the IOIO.
5. Connect Servo's VCC and GND to IOIO's 5V and GND.
6. Connect Servo's control line to IOIO pin 5.
7. Finally, connect your app loaded phone to the IOIO via USB.
8. If it works, you should see some text on the screen.
9. Control the Servo by moving your finger around on the screen.
*/

// Grab IOIO libraries
import ioio.lib.util.android.*;
import ioio.lib.spi.*;
import ioio.lib.util.*;
import ioio.lib.impl.*;
import ioio.lib.api.*;
import ioio.lib.api.exception.*;

PFont font;  // font for screen display
float servo_duty = .05; // Servo Duty Cycle, range 0.01 - 0.09
int servo_degrees = 90; // Servo Angle in degrees, range: 0 - 180

// Create IOIO object and declare thread
IOIO ioio = IOIOFactory.create();
IOIOThread thread1; 

void setup() 
{
  // Create and start IOIO thread
  thread1 = new IOIOThread("thread1", 100);
  thread1.start();
  
  noStroke(); // Turn off outlines
  fill(255,0,0); // Set fill color to red
  rectMode(CENTER); // Place rectangles by their center coordinates
  
  // Create and set font
  font = createFont("Monospaced",32);
  textFont(font);
}


void draw() 
{
  background(0); // Draw black background
  
  // Draw red 100x100 square where you touched the screen
  rect(mouseX, mouseY, 100,100); 
  
  // Set servo duty cycle between .01 and .09 (1% to 9%) 
  //  based on where you touched the screen
  servo_duty = .01+.08*((float)mouseX/(float)width); 
  
  // Calculate rough servo position based on duty cycle
  servo_degrees = round(map(servo_duty,0,.1,0,180));    
  
  // Print title
  text("Sparkfun IOIO Kit, Example 4 - Servo Control",25,25);
  
  // Print screen size
  text("Screen width:  " + width,25,75);
  text("Screen height: " + height,25,100);
  
  // Print Servo information
  text("Servo Dutycycle: " + (float)round(servo_duty*1000.0)/(float)1000.0,25,125);  // 0.0xx
  text("Servo Degrees:   " + servo_degrees,25,150);
  
  // Print X,Y coordinates of where you touched the screen
  text("X: " + mouseX,25,175);
  text("Y: " + mouseY,25,200);
}

