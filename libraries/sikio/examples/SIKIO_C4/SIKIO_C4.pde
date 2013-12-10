/* 
   SparkFun SIKIO - Circuit 4
   Hardware Concept: Servo Motor Control
   Android Concept: Screen Touch Control
   CC BY-SA, http://creativecommons.org/licenses/by-sa/3.0/
   
   PURPOSE:
   This example demonstrates how to control a servo motor using PWM output.
   
   HARDWARE:
   -Servo Motor
   
   OPERATION:
   Connect Servo's VCC and GND to IOIO-OTG's 5V and GND. Connect Servo's control
   pin to IOIO's pin 5. Once the app is loaded and your device is connected to
   the IOIO, you can control the angle of the Servo by moving your finger back
   and forth on the x axis (side to side).
*/

import ioio.lib.spi.*;
import ioio.lib.api.*;
import ioio.lib.util.*;
import ioio.lib.util.android.*;
import ioio.lib.android.bluetooth.*;
import ioio.lib.impl.*;
import sikio.*;
import ioio.lib.android.accessory.*;
import ioio.lib.api.exception.*;

PFont font;  // Font for screen display
float servo_duty = .05; // Servo Duty Cycle, range 0.01 - 0.09
int servo_degrees = 90; // Servo Angle in degrees, range: 0 - 180

void setup() 
{
  new SikioManager(this).start();
  
  noStroke(); // Turn off outlines
  fill(255,0,0); // Set fill color to red
  rectMode(CENTER); // Place rectangles by their center coordinates
  
  // Create and set font, use Monospaced as our font
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
  text("SIKIO, Circuit 4 - Servo Control",25,25);
  
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

